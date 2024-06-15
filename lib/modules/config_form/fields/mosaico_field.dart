import 'package:flutter/material.dart';

abstract class MosaicoField extends StatelessWidget
{
  final String _name;
  MosaicoField(this._name, {Key? key}) : super(key: key)
  {
    _label = _name;
  }

  /*
  * Field information
  */

  late String _label;
  void setLabel(String label)
  {
    _label = label;
  }
  String getLabel() {
    return _label;
  }

  String? _placeholder;
  void setPlaceholder(String placeholder)
  {
    _placeholder = placeholder;
  }
  String? getPlaceholder() {
    return _placeholder;
  }

  bool _required = false;
  void setRequired(bool required)
  {
    _required = required;
  }
  bool isRequired() {
    return _required;
  }

  Widget buildField(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: buildField(context),
    );
  }
}