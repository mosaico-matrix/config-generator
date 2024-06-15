import 'package:flutter/material.dart';

import 'mosaico_field.dart';

class MosaicoTextField extends MosaicoField {

  MosaicoTextField(String name, {Key? key}) : super(name, key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: getLabel(),
      ),
    );
  }
}
