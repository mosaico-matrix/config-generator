import 'package:flutter/material.dart';

class ConfirmationDialog {
  static void _doNothing() {}

  static Future<bool> ask({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            actions: [

              // Cancel button
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("Cancel",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error))),

              // Ok button
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("Ok",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary))),
            ],
          );
        });
  }
}
