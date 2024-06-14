import 'package:flutter/material.dart';
import 'package:mosaico_config_generator/form/components/component.dart';

class TextInput extends Component {
  TextInput(String name, {Key? key}) : super(name, key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Text Input'),
      ),
    );
  }
}