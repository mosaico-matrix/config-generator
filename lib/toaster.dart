import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class Toaster {
  static void show(String message, Color color, IconData icon) {
    toastification.show(
      title: Text(message),
      description: null,
      style: ToastificationStyle.flat,
      icon: Icon(icon),
      primaryColor: color,
      showProgressBar: false,
      //applyBlurEffect: true,
      pauseOnHover: true,
      autoCloseDuration: const Duration(seconds: 5),
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