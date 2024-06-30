import 'package:flutter/material.dart';
import '../../states/dynamic_form_state.dart';
import 'mosaico_field.dart';

class MosaicoStringField extends MosaicoField {

  String _value = "";
  MosaicoStringField(String name, {Key? key}) : super(name, key: key);

  @override
  Widget buildField(BuildContext context, DynamicFormState formState) {

    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      validator: (value) {
        if (value == null || value.isEmpty && isRequired()) {
          return 'Please enter some text';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: getLabel(),
        hintText: getPlaceholder(),
        hintStyle: TextStyle(color: Color(0xFFCCCCCC)),
        fillColor: Colors.transparent,
      ),
      onChanged: (value) {
        _value = value;
      },
    );
  }

  @override
  String getScriptCode() {
    return 'global ${getName()} = "$_value";';
  }
}
