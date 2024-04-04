import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../models/logs_model.dart';
import '../../themes/colors.dart';
import '../../widgets/common_text_widget.dart';
import '../../widgets/logs_item.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  final List<LogsModel> items = [
    const LogsModel('Error', '2023-11-11 :11:00', 'local',
        'www.figma.com:443 match Match() ww.figma.com:443 matcusin33333333www.figma.com:443 match Match() using ww.figma.com:443 matc'),
    const LogsModel('Error', '2023-11-11 :11:00', 'local',
        'www.figma.com:443 match Match() ww.figma.com:443 matcusin33333333www.figma.com:443 match Match() using ww.figma.com:443 matc'),
    const LogsModel('Error', '2023-11-11 :11:00', 'local',
        'www.figma.com:443 match Match() ww.figma.com:443 matcusin33333333www.figma.com:443 match Match() using ww.figma.com:443 matc'),
    const LogsModel('Error', '2023-11-11 :11:00', 'local',
        'www.figma.com:443 match Match() ww.figma.com:443 matcusin33333333www.figma.com:443 match Match() using ww.figma.com:443 matc'),
    const LogsModel('Error', '2023-11-11 :11:00', 'local',
        'www.figma.com:443 match Match() ww.figma.com:443 matcusin33333333www.figma.com:443 match Match() using ww.figma.com:443 matc'),
    const LogsModel('Error', '2023-11-11 :11:00', 'local',
        'www.figma.com:443 match Match() ww.figma.com:443 matcusin33333333www.figma.com:443 match Match() using ww.figma.com:443 matc'),
    const LogsModel('Error', '2023-11-11 :11:00', 'local',
        'www.figma.com:443 match Match() ww.figma.com:443 matcusin33333333www.figma.com:443 match Match() using ww.figma.com:443 matc'),
    const LogsModel('Error', '2023-11-11 :11:00', 'local',
        'www.figma.com:443 match Match() ww.figma.com:443 matcusin33333333www.figma.com:443 match Match() using ww.figma.com:443 matc'),
    const LogsModel('Error', '2023-11-11 :11:00', 'local',
        'www.figma.com:443 match Match() ww.figma.com:443 matcusin33333333www.figma.com:443 match Match() using ww.figma.com:443 matc'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: CommonTextWidget(
            S.of(context).history_title,
            fontSize: FontSize.large,
          ),
          centerTitle: true,
          backgroundColor: AppDarkColors.backgroundColor,
        ),
        body: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return LogsItem(
                  time: items[index].time,
                  status: items[index].status,
                  environment: items[index].environment,
                  description: items[index].description,
                );
              }),
        ));
  }
}
