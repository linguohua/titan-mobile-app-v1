import 'dart:async';
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;

import '../bean/miner_info.dart';
import 'daemon_cfgs.dart';
import 'error.dart';

class MinerBridge {
  String _token = "";
  String _id = "";
  String _areaID = "";
  int _since = 0;
  Uri? _webApiServerURL;
  String _appVersion = "";

  final logger = Logger('MinerBridge');

  final MinerInfo _info = MinerInfo();

  var _isPulling = false; // prevent duplicate pulling
  Timer?
      _timerPull; // periodic invoke http request to pull data from web-api-server
  Timer? _timerUpdateIncome;
  DateTime _currentDate = DateTime.now();

  MinerInfo get minerInfo => _info;
  String get appVersion => _appVersion;

  void setNodeInfo(String id, areaID) {
    debugPrint('info set $id');
    _id = id;
    _areaID = areaID;
  }

  void init(DaemonCfgs daemonCfgs, String appVersion) {
    _id = daemonCfgs.id();
    _token = daemonCfgs.token();
    _areaID = daemonCfgs.areaID();
    _appVersion = appVersion;
    _webApiServerURL = Uri.parse(daemonCfgs.webServerURL());

    _info.initData();
  }

  int min(int a, int b) {
    if (a < b) {
      return a;
    }

    return b;
  }

  DateTime ymd() {
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void activate() async {
    _timerPull ??
        Timer.periodic(const Duration(minutes: 1), (timer) {
          pullInfo();
        });

    _currentDate = ymd();
    _timerUpdateIncome ??
        Timer.periodic(const Duration(seconds: 5), (timer) {
          var now = ymd();
          if (now.isAfter(_currentDate)) {
            _currentDate = now;
            _info.clearIncome();
          }

          // if (BridgeMgr().daemonBridge.isEdgeOnline()) {
          //   _info.updateIncome();
          // }
          _info.updateIncome();
        });

    pullInfo();
  }

  void shutdown() {
    if (_timerPull != null) {
      _timerPull!.cancel();
      _timerPull = null;
    }

    if (_timerUpdateIncome != null) {
      _timerUpdateIncome!.cancel();
      _timerUpdateIncome = null;
    }
  }

  void pullInfo() async {
    if (_id.isEmpty) {
      return;
    }

    if (_isPulling) {
      return;
    }

    _isPulling = true;

    var client = http.Client();
    try {
      var response = await client.post(_webApiServerURL!,
          body: jsonEncode({
            'token': _token,
            'node_id': _id,
            'keys': [
              rspKeyIncome,
              rspKeyMonthIncomes,
              rspKeyAccount,
              rspKeyEpoch,
              rspKeyNodeInfo
            ],
            'since': _since,
          }));

      if (response.statusCode == 200) {
        debugPrint(response.toString());
        debugPrint(response.body.toString());
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        var since = _info.updateFromJSON(_id, decodedResponse);
        if (since != 0) {
          // remember 'since', use to inform server to reduce data size
          _since = since;
        }
      } else {
        logger.warning('get data statusCode ${response.statusCode}');
      }
    } catch (e) {
      logger.warning('get data err $e');
    } finally {
      client.close();
      _isPulling = false;
    }
  }

  void getAccountInfo(
      String code, Function(String, String, int) callback) async {
    var url = Uri.parse('$_webApiServerURL/query_code?code=$code');
    var errorCode = 0;

    var account = '';
    var address = '';

    var client = http.Client();
    try {
      var response = await client.get(url);
      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        if (decodedResponse['code'] != 0) {
          errorCode = decodedResponse['err'] != null
              ? decodedResponse['err'] as int
              : ErrorCode.unknown;
          logger.warning('getAccountInfo errorCode ${decodedResponse['err']}');
        } else {
          var data = decodedResponse['data'] != null
              ? decodedResponse['data'] as Map<String, dynamic>
              : null;
          if (data != null) {
            account = data['user_id'] as String;
            address = data['wallet_address'] as String;
          }
        }
      } else {
        errorCode = ErrorCode.network;
        logger.warning('getAccountInfo statusCode ${response.statusCode}');
      }
    } catch (e) {
      errorCode = ErrorCode.network;
      logger.warning('getAccountInfo err $e');
    } finally {
      client.close();
    }

    callback(account, address, errorCode);
  }

  Future bindingAccount(
      String hash, String sign, Function(int) callback) async {
    var url = Uri.parse('$_webApiServerURL/binding');
    var errorCode = 0;

    var client = http.Client();
    try {
      var response = await client.post(url,
          body: jsonEncode({
            'hash': hash,
            'node_id': _id,
            'signature': sign,
            'area_id': _areaID,
          }));
      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        if (decodedResponse['code'] != 0) {
          errorCode = decodedResponse['err'] != null
              ? decodedResponse['err'] as int
              : ErrorCode.unknown;

          logger.warning('bindingAccount errorCode ${decodedResponse['err']}');
        }
      } else {
        errorCode = ErrorCode.network;
        logger.warning('bindingAccount statusCode ${response.statusCode}');
      }
    } catch (e) {
      errorCode = ErrorCode.network;
      logger.warning('bindingAccount err $e');
    } finally {
      client.close();
    }

    callback(errorCode);
  }
}
