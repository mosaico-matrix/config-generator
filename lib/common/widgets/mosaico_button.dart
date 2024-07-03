import 'package:flutter/material.dart';

class MosaicoButton extends StatelessWidget {

  final Function onPressed;
  const MosaicoButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
      ),
      onPressed: () => onPressed(),
      child: Text('Add new configuration',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
    );
  }
}
