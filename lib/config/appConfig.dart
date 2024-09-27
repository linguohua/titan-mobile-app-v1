import 'package:flutter/services.dart';
import 'package:toml/toml.dart';

class AppConfig {
  static late Map<String, dynamic> _tomlConfig;

  static Future<void> load() async {
    _tomlConfig = await loadTomlConfig('assets/configs/config.toml');
  }

  static Future<Map<String, dynamic>> loadTomlConfig(String path) async {
    final tomlString = await rootBundle.loadString(path);
    final tomlMap = TomlDocument.parse(tomlString).toMap();
    return tomlMap;
  }

  static String _getProperty(String key) {
    if (_tomlConfig == null) {
      load();
      throw StateError(
          'Configuration not loaded. Call load() before accessing configuration values.');
    }
    return _tomlConfig['Network'][key];
  }

  static String get webServerURL => _getProperty('WebServerURL');

  static String get locatorURL => _getProperty('LocatorURL');

  static String get nodeInfoURL => _getProperty('NodeInfoURL');

  static String get telegeramURL => _getProperty('TelegeramURL');

  static String get twitterURL => _getProperty('TwitterURL');

  static String get bindingHelpURL => _getProperty('BindingHelpURL');

  static String get officialSiteURL => _getProperty('OfficialSiteURL');

  static String get huygensTestnetURL => _getProperty('huygensTestnetURL');

  static String get discordURL => _getProperty('discordURL');

  static String get docCNURL => _getProperty('docCNURL');

  static String get docENURL => _getProperty('docENURL');
}
