import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyApp extends StatelessWidget {
  final String msg;

  MyApp(this.msg, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countdown App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EmulatorPage(msg),
    );
  }
}

class EmulatorPage extends StatefulWidget {
  final String msg;

  const EmulatorPage(this.msg, {super.key});

  @override
  _EmulatorPageState createState() => _EmulatorPageState();
}

class _EmulatorPageState extends State<EmulatorPage> {
  int _countdown = 5; // 倒计时秒数

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
        closeApp();
      }
    });
  }

  void closeApp() {
    // 关闭应用
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('检测当前为${widget.msg}模拟器'),
      ),
      body: Center(
        child: Text(
          '倒计时: $_countdown 秒关闭',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
