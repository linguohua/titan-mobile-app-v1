

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../lang/lang.dart';

typedef ListenerList = List<Listener>;

class Listener {
  Listener({required this.tag, required this.cb});

  final String tag;
  final VoidCallback cb;
}

class ListenAble {
  final Map<String, ListenerList> _listeners = {};

  addListener(String key, String tag, VoidCallback cb) {
    var ll = _listeners[key];
    if (ll == null) {
      ll = [];
      _listeners[key] = ll;
    } else {
      ll.removeWhere((element) => element.tag == tag);
    }

    ll.add(Listener(tag: tag, cb: cb));
  }

  removeListener(String key, String tag) {
    var ll = _listeners[key];
    if (ll != null) {
      ll.removeWhere((element) => element.tag == tag);
    }
  }

  notify(String key) {
    var ll = _listeners[key];
    if (ll != null) {
      for (var l in ll) {
        l.cb();
      }
    }
  }
}

class Indicators {
  static void showMessage(BuildContext context, String title, String body,
      Image? image, Function? callback) {
    final Image picture = image ?? Image.asset('assets/images/error.png');

    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
          width: 300,
          height: 400,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 24, 24, 24),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Expanded(flex: 2, child: picture),
              Expanded(
                  flex: 1,
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  )),
              Expanded(
                flex: 2,
                child: Text(
                  body,
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
              Expanded(
                flex: 1,
                child: ConfirmButton(
                  text: Lang().dict.back,
                  callback: () {
                    if (callback != null) {
                      callback();
                    }

                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          )),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class ConfirmButton extends StatelessWidget {
  final String text;
  final Function callback;

  const ConfirmButton({super.key, required this.text, required this.callback});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          callback();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          elevation: MaterialStateProperty.all(0),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: Container(
          height: 38,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: const Color(0xFF52FF38)),
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ));
  }
}
