import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/models/config_output.dart';
import '../widgets/fields/mosaico_field.dart';


/// This class represents the state of the dynamic form.
class DynamicFormState extends ChangeNotifier {

  /*
   * Form information
   */
  String _title = "";
  String _description = "";

  /// Set the title of the form
  void setTitle(String name) {
    _title = name;
  }

  /// Get the title of the form
  String getTitle() {
    return _title;
  }

  /// Set the description of the form
  /// This can become potentially a markdown string ;)
  void setDescription(String description) {
    _description = description;
  }

  /// Get the description of the form
  String getDescription() {
    return _description;
  }

  /*
   * Name of the configuration
   * This is used to discriminate between different configurations of the same widget
   */
  String _configName = "";

  /// Set the name of the configuration
  void setConfigName(String name) {
    _configName = name;
    notifyListeners();
  }

  /// Get the name of the configuration
  String getConfigName() {
    return _configName;
  }

  /*
   * Form fields
   */
  List<MosaicoField> _fields = [];

  /// Add a field to the form
  void addField(MosaicoField field) {
    _fields.add(field);
  }

  /// Get all the fields in the form
  List<MosaicoField> getFields() {
    return _fields;
  }

  /*
   * Form validation
   */
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  GlobalKey<FormState> getFormKey() {
    return _formKey;
  }

  /// This method is used to validate the form
  bool validate() {
    return _formKey.currentState!.validate();
  }

  /*
   * Edit mode values
   */
  Map<String, dynamic> _editValues = {};

  void setPreviousDataFrom(String oldConfigDirPath) async {
    // Get config.json file
    String json = await File('$oldConfigDirPath/config.json').readAsString();
    _editValues = jsonDecode(json);
    notifyListeners();
  }

  /// Get the value of a field in edit mode
  dynamic getEditValue(String fieldName) {
    return _editValues[fieldName];
  }

  /*
   * Final output
   */
  String buildConfigScript()
  {
    String _script = "";
    for (var field in _fields) {
      _script += field.getConfigScriptLine() + "\n";
    }
    return _script;
  }
  
  String buildConfigJson() {
    Map<String, dynamic> editJson = {};
    for (var field in _fields) {
      editJson[field.getName()] = field.getConfigScriptData();
    }
    return jsonEncode(editJson);
  }


  // Export the form to a ConfigOutput object
  Future<ConfigOutput> export() async {
    var output = ConfigOutput();
    await output.initialize();
    output.setConfigName(_configName);
    output.saveConfigScript(buildConfigScript());
    output.saveConfigJson(buildConfigJson());
    return output;
  }
}
