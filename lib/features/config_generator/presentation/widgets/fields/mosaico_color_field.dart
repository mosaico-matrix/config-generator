import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mosaico_flutter_core/common/widgets/dialogs/color_picker_dialog.dart';
import 'package:mosaico_flutter_core/features/config_generator/presentation/states/fields/mosaico_field_state.dart';
import 'package:provider/provider.dart';
import '../../states/dynamic_form_state.dart';
import 'mosaico_field.dart';

class MosaicoColorField extends MosaicoField<MosaicoColorFieldState> {
  MosaicoColorField({Key? key})
      : super(fieldState: new MosaicoColorFieldState());

  @override
  Widget buildField(BuildContext context) {
    return Consumer<MosaicoColorFieldState>(
      builder: (context, state, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: state._color,
                border: Border.all(color: Colors.black),
              ),
            ),
            Text(state.getData(),
                style: TextStyle(fontSize: 20)),
            IconButton(
              icon: Icon(Icons.color_lens),
              onPressed: () async {
                await ColorPickerDialog.show(
                    context: context,
                    onColorChanged: (color) => state.setColor(color),
                    initialColor: state.getColor());
              },
            ),
          ],
        );
      },
    );
  }
}

class MosaicoColorFieldState extends MosaicoFieldState {
  /*
  * Field value
  */
  Color _color = Colors.white;

  Color getColor() => _color;

  void setColor(Color color) {
    _color = color;
    notifyListeners();
  }

  @override
  void init(oldValue) {}

  @override
  getAsset() {
    return null; // we don't need to save an asset for a color field
  }

  @override
  String? validate() {
    return null;
    // return _value.isNotEmpty || !isRequired() ? null : "This field is required";
  }

  @override
  getData() {
    return _color.toHexTriplet();
  }
}

extension ColorX on Color {
  String toHexTriplet() => '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}
