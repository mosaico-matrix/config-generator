import 'package:flutter/material.dart';

import '../dynamic_form_state.dart';

abstract class MosaicoFieldState extends ChangeNotifier {

  /*
  * Name
  */
  late String _name = "";
  void setName(String name) {
    _name = name;
  }
  String getName() {
    return _name;
  }

  /*
  * Label
  */
  late String _label;
  void setLabel(String label) {
    _label = label;
  }
  String getLabel() {
    return _label;
  }

  /*
  * Placeholder
  */
  String? _placeholder;
  void setPlaceholder(String placeholder) {
    _placeholder = placeholder;
  }
  String? getPlaceholder() {
    return _placeholder;
  }

  /*
  * Required
  */
  bool _required = false;
  void setRequired(bool required) {
    _required = required;
  }
  bool isRequired() {
    return _required;
  }

  /*
  * Edit mode
  */
  String? _oldConfigPath;
  bool get isEditMode => _oldConfigPath != null && _oldConfigPath!.isNotEmpty;
  void setOldConfigPath(String oldConfigPath) {
    _oldConfigPath = oldConfigPath;
  }
  String? getOldConfigPath() {
    return _oldConfigPath;
  }

  /*
  * Stuff to override
  */

  /// Called when form is submitted
  /// Return null if valid, error message if not
  String? validate();

  /// This method should return the field data to be available in the config json
  dynamic getData();

  /// Optional override to save an asset into the config
  dynamic getAsset();

  /// Provides the field with the old value previously saved with getData
  void init(dynamic oldValue);
}