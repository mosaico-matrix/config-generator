import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../states/dynamic_form_state.dart';
import 'mosaico_field.dart';

class MosaicoStringField extends MosaicoField<MosaicoStringFieldState> {

  MosaicoStringField(String name, {Key? key}) : super(key: key, name: name, mosaicoFieldState: MosaicoStringFieldState());

  @override
  Widget buildField(BuildContext context, DynamicFormState formState) {
    return Consumer<MosaicoStringFieldState>(
      builder: (context, state, _) {
        return TextFormField(
          controller: TextEditingController(text: state.value),
          validator: (value) {
            if (value == null || value.isEmpty && state.isRequired()) {
              return 'Please enter some text';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: state.getLabel(),
            hintText: state.getPlaceholder(),
            fillColor: Colors.transparent,
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
}
