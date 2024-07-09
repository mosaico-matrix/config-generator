import 'package:flutter/material.dart';

class TextInputDialog {
  static String enteredText = "";
  static Future<String?> show(BuildContext context, String heading, {String initialValue=""}) async {
    enteredText = initialValue;
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(heading, style: TextStyle(color: Theme.of(context).primaryColor)),
          content: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextField(
              controller: TextEditingController(text: initialValue),
              onChanged: (value) {
                enteredText = value;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:  Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Set the result to true to indicate that the user confirmed
                Navigator.of(context).pop(enteredText);
              },
              child:  Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
