import 'package:flutter/material.dart';

/// The default button used in the Mosaico project
class MosaicoButton extends StatelessWidget {

  final String text;
  final Function onPressed;
  final IconData? icon;

  const MosaicoButton(
      {super.key, required this.onPressed, required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(

      style: ButtonStyle(
        backgroundColor:
        WidgetStateProperty.all(Theme
            .of(context)
            .colorScheme
            .primary),
      ),
      onPressed: () => onPressed(),
      child:
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(child: Icon(icon, color: Theme
              .of(context)
              .colorScheme
              .onPrimary), visible: icon != null),
          SizedBox(width: icon != null ? 8 : 0),
          Text(text,
              style: TextStyle(color: Theme
                  .of(context)
                  .colorScheme
                  .onPrimary)),
        ],
      ),


    );
  }
}
