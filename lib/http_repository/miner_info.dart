import 'package:logging/logging.dart';

import '../utils/utility.dart';

const String rspKeyIncome = "income";
const String rspKeyMonthIncomes = "month_incomes";
const String rspKeyAccount = "account";
const String rspKeyEpoch = "epoch";
const String rspKeyNodeInfo = "info";

const int nodeOnlineStatus = 1;

class IncomeData {
  IncomeData({required this.x, required this.y});

  String x;
  double y;
  bool bSelected = false;
}

class RspIncome {
  RspIncome({required this.today, required this.total});
  double today; // index
  double total; // value

  factory RspIncome.fromMap(Map<String, dynamic> map) {
    dynamic today = map['today'] ?? 0;
    double todayDouble = today is int ? today.toDouble() : today as double;

    dynamic total = map['total'] ?? 0;
    double totalDouble = total is int ? total.toDouble() : total as double;
    return RspIncome(
      today: todayDouble,
      total: totalDouble,
    );
  }
}

class RspEpoch {
  RspEpoch({required this.token});
  String token;

  factory RspEpoch.fromMap(Map<String, dynamic> map) {
    return RspEpoch(
      token: map['token'] as String,
    );
  }
}

class RspNodeInfo {
  RspNodeInfo({required this.incr});

  double incr;

  factory RspNodeInfo.fromMap(Map<String, dynamic> map) {
    dynamic incomeIncr = map['income_incr'] ?? 0;
    double incrDouble =
        incomeIncr is int ? incomeIncr.toDouble() : incomeIncr as double;

    return RspNodeInfo(
      incr: incrDouble,
    );
  }
}

class RspAccount {
  RspAccount(
      {required this.account, required this.address, required this.code});
  String account;
  String address;
  String code;

  factory RspAccount.fromMap(Map<String, dynamic> map) {
    return RspAccount(
      account: map['user_id'] as String,
      address: map['wallet_address'] as String,
      code: map['code'] as String,
    );
  }
}

class RspIncomes {
  RspIncomes({required this.incomeList});
  List<IncomeData> incomeList; // index

  factory RspIncomes.fromMap(List<dynamic> list) {
    List<IncomeData> incomes = [];

    for (final dynamic info in list) {
      dynamic income = info['v'] ?? 0;
      double incrDouble = income is int ? income.toDouble() : income as double;

      var incomeD = IncomeData(x: info['k'], y: incrDouble);
      incomes.add(incomeD);
    }

    return RspIncomes(
      incomeList: incomes,
    );
  }
}

class RspData {
  RspData({
    this.income,
    this.monthIncomes,
    required this.since,
    this.accountInfo,
    this.epochInfo,
    this.nodeInfo,
  });
  RspIncome? income;
  RspIncomes? monthIncomes;
  int since;
  RspAccount? accountInfo;
  RspEpoch? epochInfo;
  RspNodeInfo? nodeInfo;

  factory RspData.fromMap(Map<String, dynamic> map) {
    return RspData(
      income: map[rspKeyIncome] != null
          ? RspIncome.fromMap(map[rspKeyIncome] as Map<String, dynamic>)
          : null,
      monthIncomes: map[rspKeyMonthIncomes] != null
          ? RspIncomes.fromMap(map[rspKeyMonthIncomes] as List<dynamic>)
          : null,
      epochInfo: map[rspKeyEpoch] != null
          ? RspEpoch.fromMap(map[rspKeyEpoch] as Map<String, dynamic>)
          : null,
      nodeInfo: map[rspKeyNodeInfo] != null
          ? RspNodeInfo.fromMap(map[rspKeyNodeInfo] as Map<String, dynamic>)
          : null,
      since: map['since'] != null ? map['since'] as int : 0,
      accountInfo: map[rspKeyAccount] != null
          ? RspAccount.fromMap(map[rspKeyAccount] as Map<String, dynamic>)
          : null,
    );
  }
}

class NodeInfoRsp {
  NodeInfoRsp({required this.code, required this.data});
  int code;
  RspData? data; // value

  factory NodeInfoRsp.fromMap(Map<dynamic, dynamic> map) {
    return NodeInfoRsp(
      code: map['code'] as int,
      data: map['data'] != null
          ? RspData.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class MinerInfo extends ListenAble {
  final String _nodeID = "";

  double _todayIncome = 0;
  double _totalIncome = 0;
  double _yesterdayIncome = 0;
  double _monthIncome = 0;
  double _weekIncome = 0;
  String _tokenUnit = 'TTN';
  double _incomeIncr = 0;

  String account = "";
  String address = "";
  String bindingCode = "";

  final logger = Logger('MinerInfo');

  List<IncomeData> _weeksIncomes = [];
  List<IncomeData> _monthsIncomes = [];

  void initData() {
    DateTime now = DateTime.now();
    for (int i = 14; i > 0; i--) {
      DateTime dayAgo = now.subtract(Duration(days: i));

      String m = dayAgo.month.toString().padLeft(2, '0');
      String d = dayAgo.day.toString().padLeft(2, '0');

      var income = IncomeData(x: '$m-$d', y: 0);
      _weeksIncomes.add(income);
    }
  }

  void updateIncome() {
    if (_incomeIncr <= 0) {
      return;
    }

    _todayIncome += _incomeIncr;
    notify("income");
  }

  void clearIncome() {
    _todayIncome = 0;
  }

  int updateFromJSON(String nodeID, Map jMap) {
    logger.info('jMap: $jMap');

    var rspBody = NodeInfoRsp.fromMap(jMap);
    if (rspBody.code != 0) {
      return 0;
    }

    var data = rspBody.data;
    if (data == null) {
      return 0;
    }

    var isIncomeNotify = false;
    var isIncomesNotify = false;

    var income = data.income;
    if (income != null) {
      // income
      if (income.today > _todayIncome) {
        _todayIncome = income.today;
      }
      _totalIncome = income.total;

      isIncomeNotify = true;
    }

    var epochInfo = data.epochInfo;
    if (epochInfo != null) {
      if (_tokenUnit != epochInfo.token) {
        _tokenUnit = epochInfo.token;

        isIncomeNotify = true;
        isIncomesNotify = true;
      }
    }

    var nodeInfo = data.nodeInfo;
    if (nodeInfo != null) {
      _incomeIncr = nodeInfo.incr / 360;
    }

    var monthIncomeInfo = data.monthIncomes;
    if (monthIncomeInfo != null) {
      _weekIncome = 0;
      _monthIncome = 0;

      _monthsIncomes = monthIncomeInfo.incomeList;

      var le = _monthsIncomes.length;
      if (le < 30) {
        List<IncomeData> temps = [];
        DateTime now = DateTime.now();
        for (le; le < 30; le++) {
          DateTime dayAgo = now.subtract(Duration(days: 30 - le));

          String m = dayAgo.month.toString().padLeft(2, '0');
          String d = dayAgo.day.toString().padLeft(2, '0');

          var income = IncomeData(x: '$m-$d', y: 0);
          temps.add(income);
        }
        temps.addAll(_monthsIncomes);

        _monthsIncomes = temps;
      }

      // week
      _weeksIncomes = _monthsIncomes.sublist(_monthsIncomes.length - 14);

      for (final IncomeData info in _weeksIncomes) {
        _weekIncome += info.y;
      }

      for (final IncomeData info in _monthsIncomes) {
        _monthIncome += info.y;
      }

      _yesterdayIncome = _weeksIncomes[12].y;

      isIncomeNotify = true;
      isIncomesNotify = true;
    }

    if (isIncomeNotify) {
      notify("income");
    }

    if (isIncomesNotify) {
      notify("incomeChart");
    }

    var aInfo = data.accountInfo;
    if (aInfo != null &&
        (aInfo.account != account ||
            aInfo.address != address ||
            aInfo.code != bindingCode)) {
      address = aInfo.address;
      account = aInfo.account;
      bindingCode = aInfo.code;

      notify("account");
    }

    return data.since;
  }

  double totalIncome() {
    return _totalIncome;
  }

  double yesterdayIncome() {
    return _yesterdayIncome;
  }

  double todayIncome() {
    return _todayIncome;
  }

  double weekIncome() {
    return _weekIncome;
  }

  double monthIncome() {
    return _monthIncome;
  }

  String tokenUnit() {
    return _tokenUnit;
  }

  String nodeID() {
    return _nodeID;
  }

  List<IncomeData> weeksIncomes() {
    return _weeksIncomes;
  }

  List<IncomeData> monthsIncomes() {
    return _monthsIncomes;
  }
}
