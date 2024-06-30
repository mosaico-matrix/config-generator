import 'package:flutter/material.dart';

class ColorPickerDialog {
  static Future<Future> show(BuildContext context,
      ValueChanged<Color> onColorChanged, {Color? initialColor}) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.9),
          shadowColor: Colors.black,
          surfaceTintColor: Colors.white,
          title: const Text('Scegli un colore'),
          content: Container(),
          // content: SingleChildScrollView(
          //   child: ColorPicker(
          //     hexInputBar: true,
          //     labelTypes: const [ColorLabelType.rgb],
          //     enableAlpha: false,
          //     pickerColor: initialColor ?? Colors.white,
          //     onColorChanged: onColorChanged,
          //   ),
          // ),
        );
      },
    );
  }
}
