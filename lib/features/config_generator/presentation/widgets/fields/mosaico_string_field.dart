import 'package:flutter/material.dart';
import 'package:mosaico_flutter_core/features/config_generator/presentation/states/fields/mosaico_field_state.dart';
import 'package:provider/provider.dart';
import '../../states/dynamic_form_state.dart';
import 'mosaico_field.dart';

class MosaicoStringField extends MosaicoField<MosaicoStringFieldState> {

  MosaicoStringField({Key? key}) : super(fieldState: new MosaicoStringFieldState());

  @override
  Widget buildField(BuildContext context) {
    return Consumer<MosaicoStringFieldState>(
      builder: (context, state, _) {
        return TextField(
          controller: TextEditingController(text: state.value),
          decoration: InputDecoration.collapsed(
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
            hintText: state.getPlaceholder(),
          ),
          onChanged: (value) {
            state.setValue(value);
          },
        );
      },
    );
  }

}

class MosaicoStringFieldState extends MosaicoFieldState {

  /*
  * Field value
  */
  String _value = "";

  String get value => _value;
  void setValue(String value) {
    _value = value;
  }

  @override
  saveDataForEdit() {
    return _value;
  }

  @override
  String getConfigScriptLine() {
    return '${getName()} = "$_value"';
  }

  @override
  void init(oldValue) {
    _value = oldValue ?? "";
    notifyListeners();
  }

  @override
  getAsset() {
    return null; // we don't need to save an asset for a string field
  }

  @override
  String? validate() {
    return _value.isNotEmpty || !isRequired() ? null : "This field is required";
  }
}
