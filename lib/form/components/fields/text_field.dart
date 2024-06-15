import 'package:flutter/material.dart';
import 'package:mosaico_config_generator/form/components/fields/field.dart';

class TextField extends Field {

  TextField(String name, {Key? key}) : super(name, key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Text Input'),
      ),
    );
  }
}