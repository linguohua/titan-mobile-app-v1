import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:sidebarx/sidebarx.dart';

import '../../bean/log.dart';

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

  @override
  void initState() {
    super.initState();
    loadLogFiles();
  }

  void loadLogFile(int index) async {
    String filePath = logFiles[index];
    var list = await LogManager.readLogEntries(filePath);
    _controller.selectIndex(index);

    setState(() {
      selectedFileLogs = list;
    });
  }

  void loadLogFiles() async {
    final directory = Directory(LogManager.getLogDir());
    var files = directory.listSync();
    setState(() {
      logFiles = files.map((file) => file.path).toList();
      logFiles = logFiles.reversed.toList();

      if (logFiles.isNotEmpty) {
        loadLogFile(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Row(
            children: [
              Flexible(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 70),
                    decoration: BoxDecoration(
                      color: c181818Color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListView.builder(
                      itemCount: logFiles.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(path.basename(logFiles[index]),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: _controller.selectedIndex == index
                                        ? const Color.fromARGB(255, 82, 255, 56)
                                        : Colors.white,
                                  ))),
                          onTap: () {
                            loadLogFile(index);
                          },
                        );
                      },
                    ),
                  )),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                  flex: 5,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 70),
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
        ));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //         title: CommonTextWidget(
  //           S.of(context).history_title,
  //           fontSize: FontSize.large,
  //         ),
  //         centerTitle: true,
  //         backgroundColor: AppDarkColors.backgroundColor,
  //       ),
  //       body: Container(
  //         margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
  //         child: ListView.builder(
  //             itemCount: selectedFileLogs.length,
  //             itemBuilder: (context, index) {
  //               var log = selectedFileLogs[index];
  //
  //               Color textColor = AppDarkColors.titleColor;
  //               if (log.level == Level.WARNING.name || log.level == 'warning') {
  //                 textColor = Colors.orange;
  //               } else if (log.level == Level.SEVERE.name ||
  //                   log.level == 'error') {
  //                 textColor = Colors.red;
  //               }
  //               return LogsItem(
  //                   environment: '${log.level} - ${log.ts}',
  //                   description: log.msg,
  //                   textColor: textColor);
  //             }),
  //       ));
  // }
}
