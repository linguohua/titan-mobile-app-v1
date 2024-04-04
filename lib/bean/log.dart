import 'dart:convert';
import 'dart:io';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'dart:async';

import 'bridge_mgr.dart';

class LogEntry {
  final String level;
  final String ts;
  final String msg;
  final String logger;

  LogEntry(
      {required this.level,
      String? ts,
      required this.msg,
      required this.logger})
      : ts = ts ?? DateTime.now().toString();

  Map<String, dynamic> toJson() {
    return {
      'level': level.toString().split('.').last,
      'ts': ts,
      'msg': msg,
      'logger': logger,
    };
  }

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      level: json['level'] as String,
      ts: json['ts'] as String,
      msg: json['msg'] as String,
      logger: json['logger'] as String,
    );
  }
}

class LogManager {
  List<LogEntry> entryList = [];
  Timer? _timer;

  Future<void> init(bool saved) async {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      if (saved) {
        entryList.add(LogEntry(
            level: record.level.name,
            msg: record.message,
            logger: record.loggerName));

        return;
      }

      stdout.writeln(
          '${record.level.name}: ${record.time.toString()}: ${record.message}');
    });

    // create log dir
    var logDir = getLogDir();
    var directory = Directory(logDir);
    // if (!directory.existsSync()) {
    //   directory.createSync(recursive: true);
    // }
    if (!await directory.exists()) {
      await directory.create();
    }
  }

  void activate() async {
    if (_timer != null) {
      throw Exception("log manager already been activated");
    }

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (entryList.isEmpty) {
        return;
      }

      var temp = entryList;
      entryList = [];

      saveLogEntry(temp);
    });
  }

  void shutdown() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  Future<void> saveLogEntry(List<LogEntry> list) async {
    if (list.isEmpty) {
      return;
    }

    final date = DateTime.now();
    final filePath = getLogFilePath(date);

    final file = File(filePath);
    await file.parent.create(recursive: true);

    var logEntryJson = "";
    for (var e in list) {
      final s = jsonEncode(e.toJson());
      logEntryJson = '$logEntryJson$s\n';
    }

    await file.writeAsString(logEntryJson, mode: FileMode.append);
  }

  static Future<List<LogEntry>> readLogEntries(String filePath) async {
    // final filePath = getLogFilePath(date);
    final file = File(filePath);

    final exists = await file.exists();
    if (!exists) {
      return [];
    }

    final fileContent = await file.readAsString();
    final logEntries = fileContent
        .trim()
        .split('\n')
        .where((line) => line.isNotEmpty)
        .map((line) => LogEntry.fromJson(jsonDecode(line)))
        .toList();

    return logEntries.reversed.toList();
  }

  String getLogFilePath(DateTime date) {
    final fileName =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    var dir = getLogDir();
    return path.join(dir, fileName);
  }

  static String getLogDir() {
    return path.join(BridgeMgr().appDocPath, "logs");

    // if (kDebugMode) {
    //   return path.join(Directory.current.path, "logs");
    // }

    // String executablePath = Platform.resolvedExecutable;
    // return path.join(path.dirname(executablePath), "logs");
  }
}
