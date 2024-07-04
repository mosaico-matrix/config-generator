import 'package:flutter/material.dart';

/// The default text button used in the Mosaico project
class MosaicoTextButton extends StatelessWidget {

  final String text;
  final Function onPressed;
  const MosaicoTextButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(),
      child: Text(text,
          style: TextStyle(color: Theme.of(context).colorScheme.primary)),
    );
  }
}
