import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:sidebarx/sidebarx.dart';

import '../../bridge/log.dart';
import '../../l10n/generated/l10n.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  List<String> logFiles = [];
  List<LogEntry> selectedFileLogs = [];
  final c181818Color = const Color.fromARGB(255, 24, 24, 24);
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  String logFolder = "";

  @override
  void initState() {
    super.initState();
    loadLogFiles();
  }

  void loadLogFiles() async {
    final directory = Directory(LogManager.getLogDir());
    var edgeDir = await LogManager.getLogEdgeFilePath();
    var files = await directory.list().toList();
    logFolder = directory.path;

    files
        .sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    setState(() {
      logFiles = files.map((file) => file.path).toList();
      logFiles.add(edgeDir);

      try {
        logFiles.sort((a, b) {
          if (a.contains("edge.log")) {
            return -1;
          } else if (b.contains("edge.log")) {
            return 1;
          } else {
            return path.basename(b).compareTo(path.basename(a));
          }
        });
      } catch (e) {
        debugPrint(e.toString());
      }
      if (logFiles.isNotEmpty) {
        loadLogFile(0);
      }
    });
  }

  void loadLogFile(int index) async {
    String filePath = logFiles[index];
    var list = await LogManager.readLogEntries(filePath);
    _controller.selectIndex(index);
    setState(() {
      selectedFileLogs = list;
    });
  }

  List<T> getFirst10Items<T>(List<T> items, size) {
    return items.length >= size ? items.sublist(0, size) : items;
  }

  void _copyToClipboard() {
    var list = getFirst10Items(selectedFileLogs, 15);
    var str = jsonEncode(list);
    if (str.length > 5000) {
      var list = getFirst10Items(selectedFileLogs, 12);
      str = jsonEncode(list);
    }
    if (str.length > 5000) {
      var list = getFirst10Items(selectedFileLogs, 10);
      str = jsonEncode(list);
    }

    if (str.length > 5000) {
      var list = getFirst10Items(selectedFileLogs, 8);
      str = jsonEncode(list);
    }

    if (str.length > 5000) {
      var list = getFirst10Items(selectedFileLogs, 5);
      str = jsonEncode(list);
    }

    Clipboard.setData(ClipboardData(text: "${str}"));
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: S.of(context).copiedPasteboard,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Row(
                children: [
                  Flexible(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: c181818Color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 300,
                              child: ListView.separated(
                                itemCount: logFiles.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    child: Center(
                                      child: Text(
                                          path.basename(logFiles[index]
                                              .replaceAll(".log", "")),
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: _controller.selectedIndex ==
                                                    index
                                                ? const Color.fromARGB(
                                                    255, 82, 255, 56)
                                                : Colors.white,
                                          )),
                                    ),
                                    onTap: () {
                                      loadLogFile(index);
                                    },
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(height: 15);
                                },
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              height: 30,
                              child: GestureDetector(
                                onTap: () {
                                  _copyToClipboard();
                                },
                                child: Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: const Color(0xFF52FF38)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    S.of(context).oneCopy,
                                    style: const TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: c181818Color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListView.builder(
                          itemCount: selectedFileLogs.length,
                          itemBuilder: (context, index) {
                            var log = selectedFileLogs[index];
                            var color = Colors.blue;
                            if (log.level == Level.WARNING.name ||
                                log.level == 'warning') {
                              color = Colors.orange;
                            } else if (log.level == Level.SEVERE.name ||
                                log.level == 'error') {
                              color = Colors.red;
                            }

                            return ListTile(
                              title: Text('${log.level} - ${log.ts}',
                                  style: TextStyle(color: color)),
                              subtitle: Text(log.msg,
                                  style: const TextStyle(color: Colors.white)),
                            );
                          },
                        ),
                      )),
                ],
              ),
            )));
  }
}
