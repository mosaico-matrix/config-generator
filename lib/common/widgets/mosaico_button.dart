import 'package:flutter/material.dart';

/// The default button used in the Mosaico project
class MosaicoButton extends StatelessWidget {

  final String text;
  final Function onPressed;
  const MosaicoButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
      ),
      onPressed: () => onPressed(),
      child: Text(text,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
    );
  }
}
