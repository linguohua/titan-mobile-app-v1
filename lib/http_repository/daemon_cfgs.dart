import 'dart:convert';
import 'package:path/path.dart' as path;

import '../bean/bridge_mgr.dart';

class DaemonCfgs {
  DaemonCfgs({required this.kvMap}) {
    _resolveStoragePath(kvMap);
  }

  final Map<String, dynamic> kvMap;

  final _version = "v1.0.0";

  String _id = "";
  String _areaID = "";

  final bool _saveLog = false;

  static const String _keyNetwork = "Network";
  static const String _keyWebServerURL = "WebServerURL";
  static const String _keyTelegeramURL = "TelegeramURL";
  static const String _keyTwitterURL = "TwitterURL";
  static const String _keyNodeInfoURL = "NodeInfoURL";
  static const String _keyBindingHelpURL = "BindingHelpURL";
  static const String _keyLocatorURL = "LocatorURL";

  static const String _keyBandwidth = "Bandwidth";
  static const String _keyBandwidthMB = "BandwidthMB";

  static const String _keyStorage = "Storage";
  static const String _keyStorageGB = "StorageGB";
  static const String _keyStoragePath = "Path";

  static const String _keyMemory = "Memory";
  static const String _keyMemoryGB = "MemoryGB";

  static const String _keyCPU = "CPU";
  static const String _keyCPUCores = "Cores";

  static const String _keyBasic = "Basic";
  static const String _keyBasicToken = "Token";

  static const String _keyMin = "Min";
  static const String _keyMax = "Max";
  static const String _keyStep = "Step";

  static const String _keyNodeID = "node_id";
  static const String _keyAreaID = "area_id";

  String version() {
    return _version;
  }

  String id() {
    if (_id.isEmpty) {
      var tk = kvMap[_keyBasic][_keyBasicToken];
      if (tk.isNotEmpty) {
        var map = decodeToken(tk);
        if (map.containsKey(_keyNodeID)) {
          _id = map[_keyNodeID];
        }
      }
    }

    return _id;
  }

  String areaID() {
    if (_areaID.isEmpty) {
      var tk = kvMap[_keyBasic][_keyBasicToken];
      if (tk.isNotEmpty) {
        var map = decodeToken(tk);
        if (map.containsKey(_keyAreaID)) {
          _areaID = map[_keyAreaID];
        }
      }
    }

    return _areaID;
  }

  //https://api-test1.container1.titannet.io/api/v2/device
  //https://test1.titannet.io/nodeidDetail
  String webServerURL() {
    return kvMap[_keyNetwork][_keyWebServerURL]?? 'https://api-test1.container1.titannet.io/api/v2/device';
  }

  String nodeInfoURL() {
    return kvMap[_keyNetwork][_keyNodeInfoURL]??'';
  }

  String telegeramURL() {
    return kvMap[_keyNetwork][_keyTelegeramURL]??'';
  }

  String twitterURL() {
    return kvMap[_keyNetwork][_keyTwitterURL]??'';
  }

  String bindingHelpURL() {
    return kvMap[_keyNetwork][_keyBindingHelpURL]??'';
  }

  bool saveLog() {
    return _saveLog;
  }

  String locatorURL() {
    return kvMap[_keyNetwork][_keyLocatorURL]??'';
  }

  setToken(String tk) {
    if (kvMap[_keyBasic][_keyBasicToken].isNotEmpty) {
      return;
    }
    kvMap[_keyBasic][_keyBasicToken] = tk;
  }

  String token() {
    return kvMap[_keyBasic][_keyBasicToken]??'';
  }

  void setBandwidth(int bandwidth) {
    kvMap[_keyBandwidth][_keyBandwidthMB] = bandwidth;
  }

  void setCpuCores(int cpucores) {
    kvMap[_keyCPU][_keyCPUCores] = cpucores;
  }

  void setStorageGb(int storagegb) {
    kvMap[_keyStorage][_keyStorageGB] = storagegb;
  }

  void setStoragePath(String p) {
    kvMap[_keyStorage][_keyStoragePath] = p;
  }

  String storagePath() {
    return kvMap[_keyStorage][_keyStoragePath]??'';
  }

  void setMemGb(int memgb) {
    kvMap[_keyMemory][_keyMemoryGB] = memgb;
  }

  // Getter methods
  int bandwidth() {
    return kvMap[_keyBandwidth][_keyBandwidthMB]??0;
  }

  int cpuCores() {
    return kvMap[_keyCPU][_keyCPUCores]??0;
  }

  int storageGb() {
    return kvMap[_keyStorage][_keyStorageGB]??0;
  }

  int memGb() {
    return kvMap[_keyMemory][_keyMemoryGB]??0;
  }

  int minBandwidth() {
    return kvMap[_keyBandwidth][_keyMin]??0;
  }

  int maxBandwidth() {
    return kvMap[_keyBandwidth][_keyMax]??0;
  }

  int bandwidthDivisions() {
    var bandwidthStep = kvMap[_keyBandwidth][_keyStep]??0;
    return ((maxBandwidth() - minBandwidth()) / bandwidthStep).floor();
  }

  int minStorage() {
    return kvMap[_keyStorage][_keyMin]??0;
  }

  int maxStorage() {
    return kvMap[_keyStorage][_keyMax] ?? 0;
  }

  int storageDivisions() {
    var storageStep = kvMap[_keyStorage][_keyStep]??0;
    return ((maxStorage() - minStorage()) / storageStep).floor();
  }

  int minMem() {
    return kvMap[_keyMemory][_keyMin]??0;
  }

  int maxMem() {
    return kvMap[_keyMemory][_keyMax]??0;
  }

  int memDivisions() {
    var memStep = kvMap[_keyMemory][_keyStep]??0;
    return ((maxMem() - minMem()) / memStep).floor();
  }

  int minCpuCores() {
    return kvMap[_keyCPU][_keyMin]??0;
  }

  int maxCpuCores() {
    return kvMap[_keyCPU][_keyMax]??0;
  }

  int cpuCoresDivisions() {
    var cpuCoresStep = kvMap[_keyCPU][_keyStep]??0;
    return ((maxCpuCores() - minCpuCores()) / cpuCoresStep).floor();
  }

  String cpuCoresUnit() {
    return "core";
  }

  Map<String, dynamic> decodeToken(String token) {
    var tk = utf8.decode(base64.decode(token));
    return jsonDecode(tk);
  }

  // mergeToml merge current config to default config
  static Map<String, dynamic> mergeToml(
      Map<String, dynamic> defaultConfig, Map<String, dynamic> currentConfig) {
    var mmap = defaultConfig;

    if (currentConfig.containsKey(_keyBandwidth) &&
        currentConfig[_keyBandwidth].containsKey(_keyBandwidthMB)) {
      mmap[_keyBandwidth][_keyBandwidthMB] =
          currentConfig[_keyBandwidth][_keyBandwidthMB];
    }

    if (currentConfig.containsKey(_keyStorage)) {
      if (currentConfig[_keyStorage].containsKey(_keyStorageGB)) {
        mmap[_keyStorage][_keyStorageGB] =
            currentConfig[_keyStorage][_keyStorageGB];
      }

      if (currentConfig[_keyStorage].containsKey(_keyStoragePath)) {
        mmap[_keyStorage][_keyStoragePath] =
            currentConfig[_keyStorage][_keyStoragePath];
      }
    }

    if (currentConfig.containsKey(_keyMemory) &&
        currentConfig[_keyMemory].containsKey(_keyMemoryGB)) {
      mmap[_keyMemory][_keyMemoryGB] = currentConfig[_keyMemory][_keyMemoryGB];
    }

    if (currentConfig.containsKey(_keyCPU) &&
        currentConfig[_keyCPU].containsKey(_keyCPUCores)) {
      mmap[_keyCPU][_keyCPUCores] = currentConfig[_keyCPU][_keyCPUCores];
    }

    if (currentConfig.containsKey(_keyBasic) &&
        currentConfig[_keyBasic].containsKey(_keyBasicToken)) {
      mmap[_keyBasic][_keyBasicToken] =
          currentConfig[_keyBasic][_keyBasicToken];
    }

    return mmap;
  }

  void _resolveStoragePath(Map<String, dynamic> kvMap) {
    var daemonPath = BridgeMgr().appDocPath;

    var prefix = "./";
    var p = kvMap[_keyStorage][_keyStoragePath];
    if (p.startsWith(prefix)) {
      p = p.substring(prefix.length);
      p = path.join(daemonPath, p);
    }
    kvMap[_keyStorage][_keyStoragePath] = p;
  }
}
