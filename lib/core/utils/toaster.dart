import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

/// This class is used to show toast without context for messages/errors
class Toaster {
  /*
  * Modify global config
  */
  static Alignment _alignment = Alignment.topRight;

  static void setAlignment(Alignment alignment) {
    _alignment = alignment;
  }

  static void show(String message, Color color, IconData icon) {
    BotToast.showCustomText(
      onlyOne: true,
      duration: const Duration(seconds: 3),
      toastBuilder: (cancel) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: color,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ));
      },
    );
  }

  static void success(String message) {
    show(message, Colors.green, CupertinoIcons.check_mark_circled);
  }

  static void error(String message) {
    show(message, Colors.red, CupertinoIcons.xmark_circle);
  }

  static void warning(String message) {
    show(message, Colors.orange, CupertinoIcons.exclamationmark_triangle);
  }

  static void info(String message) {
    show(message, Colors.blue, CupertinoIcons.info);
  }
}
