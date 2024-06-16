import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../fields/mosaico_field.dart';

/// This class represents the state of the dynamic form.
class DynamicFormState extends ChangeNotifier {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DynamicFormState();

  /**
   * Form information
   */
  String _title = "";
  String _description = "";

  /// Set the title of the form
  void setTitle(String name)
  {
    _title = name;
  }

  /// Get the title of the form
  String getTitle()
  {
    return _title;
  }

  /// Set the description of the form
  /// This can become potentially a markdown string ;)
  void setDescription(String description)
  {
    _description = description;
  }

  /// Get the description of the form
  String getDescription()
  {
    return _description;
  }

  /**
   * Form fields
   */
  List<MosaicoField> _fields = [];

  /// Add a field to the form
  void addField(MosaicoField field)
  {
    _fields.add(field);
  }

  /// Get all the fields in the form
  List<MosaicoField> getFields()
  {
    return _fields;
  }

  /**
  * Form validation
  */
  GlobalKey<FormState> getFormKey()
  {
    return _formKey;
  }

  /// This method is used to validate the form
  bool validate() {
    return _formKey.currentState!.validate();
  }
}
