import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog {
  static void _doNothing() {}

  static void show(BuildContext context, String title,
      String message, VoidCallback onConfirm,
      {VoidCallback onCancel = _doNothing}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(onPressed: ()=> {Navigator.of(context).pop(true), onCancel()}, child: const Text("Annulla")),
              TextButton(onPressed: ()=> {Navigator.of(context).pop(true), onConfirm()}, child: const Text("Ok")),
            ],
          );
        });
  }
}
