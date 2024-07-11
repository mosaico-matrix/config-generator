import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog {
  static Future<Color> show(BuildContext context, {Color? initialColor}) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.9),
          shadowColor: Colors.black,
          surfaceTintColor: Colors.white,
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              hexInputBar: true,
              labelTypes: const [ColorLabelType.rgb],
              enableAlpha: false,
              pickerColor: initialColor ?? Colors.white,
              onColorChanged: (color) {
                Navigator.of(context).pop(color);
              },
            ),
          ),
        );
      },
    );
  }
}
