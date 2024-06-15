import 'dart:convert';

import 'package:mosaico_config_generator/form/config_output.dart';
import '../components/fields/field.dart';
import '../components/fields/text_field.dart';
import 'package:flutter/material.dart' show ChangeNotifier;

class ConfigFormState extends ChangeNotifier {

  final List<Field> components = [];
  final String jsonContent;


  /// Parses the given JSON string and creates a new [ConfigurationParser] object.
  ConfigFormState(this.jsonContent) {

    // Parse JSON content
    var json = jsonDecode(jsonContent);

    // // Create components
    // for (var component in json['components']) {
    //   //addComponent(component);
    // }


    var component = TextField('first_name');
    addComponentAttributes(component, {'label': 'First Name'});
    components.add(component);
  }

  void addComponentAttributes(Field component, Map<String, dynamic> attributes)
  {
    component.setLabel(attributes['label']);
  }
}