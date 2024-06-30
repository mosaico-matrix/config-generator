import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../states/dynamic_form_state.dart';

abstract class MosaicoField extends StatelessWidget
{
  MosaicoField(this._name, {Key? key}) : super(key: key)
  {
    _label = _name;
  }

  /*
  * Basic field stuff
  */
  final String _name;
  String getName()
  {
    return _name;
  }

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

  /*
  * These need to be implemented by the subclasses
  */

  /// This method should return the widget that represents the field
  Widget buildField(BuildContext context, DynamicFormState state);

  /// This method should return the script code to run before the widget script is loaded onto the matrix
  String getScriptCode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: buildField(context, Provider.of<DynamicFormState>(context))
    );
  }
}