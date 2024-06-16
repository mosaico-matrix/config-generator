import 'package:flutter/material.dart';

import 'mosaico_field.dart';

class MosaicoStringField extends MosaicoField {

  MosaicoStringField(String name, {Key? key}) : super(name, key: key);

  @override
  Widget buildField(BuildContext context) {

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
      onFieldSubmitted: (value) {
        print(value);
      },
    );
  }
}
