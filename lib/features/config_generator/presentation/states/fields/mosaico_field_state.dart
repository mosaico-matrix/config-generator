import 'package:flutter/material.dart';

import '../dynamic_form_state.dart';

abstract class MosaicoFieldState extends ChangeNotifier {

  /*
  * Basic field stuff
  */
  late String _name = "";
  void setName(String name) {
    _name = name;
  }
  String getName() {
    return _name;
  }

  late String _label;

  void setLabel(String label) {
    _label = label;
  }

  String getLabel() {
    return _label;
  }

  String? _placeholder;

  void setPlaceholder(String placeholder) {
    _placeholder = placeholder;
  }

  String? getPlaceholder() {
    return _placeholder;
  }

  bool _required = false;

  void setRequired(bool required) {
    _required = required;
  }

  bool isRequired() {
    return _required;
  }

  /*
  * Stuff to override
  */

  /// This method should return the script code to run before the widget script is loaded onto the matrix
  String getConfigScriptLine();

  /// This method should save the field data to edit it later
  dynamic saveDataForEdit();

  /// Provides the field with the old value
  void init(dynamic oldValue);

  /// Optional override to get an asset
  dynamic getAsset(){
    return null;
  }
}