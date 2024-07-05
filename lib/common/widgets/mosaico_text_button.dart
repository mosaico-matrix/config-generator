import 'package:flutter/material.dart';

/// The default text button used in the Mosaico project
class MosaicoTextButton extends StatelessWidget {

  final String text;
  final Function onPressed;
  bool invertColor = false;
  MosaicoTextButton({super.key, required this.onPressed, required this.text, this.invertColor = false});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(),
      child: Text(text,
          style: TextStyle(color: invertColor ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary)),
    );
  }
}
