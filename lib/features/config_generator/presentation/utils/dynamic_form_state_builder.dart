import 'dart:convert';
import 'package:mosaico_flutter_core/features/config_generator/presentation/widgets/fields/mosaico_image_field.dart';
import 'package:mosaico_flutter_core/features/config_generator/presentation/widgets/fields/mosaico_string_list_field.dart';

import '../states/dynamic_form_state.dart';
import '../widgets/fields/mosaico_field.dart';
import '../widgets/fields/mosaico_string_field.dart';

class DynamicFormStateBuilder {

  /// The form that is being built
  DynamicFormState _formModel = DynamicFormState();


  /// Adds the common attributes to a generic mosaico component
  void _addComponentAttributes(MosaicoField component,
      Map<String, dynamic> attributes, String fieldName) {
    component.getState().setName(fieldName);
    component.getState().setLabel(attributes['label'] ?? fieldName);
    component.getState().setPlaceholder(attributes['placeholder'] ?? '');
    component.getState().setRequired(attributes['required']);
    component.getState().setOldConfigPath(_formModel.getOldConfigDirPath());
  }

  DynamicFormStateBuilder(Map<String, dynamic> configForm, String? oldConfigDirPath) {

    // Check if need to set old config path
    if (oldConfigDirPath != null) {
      _formModel.setPreviousDataFrom(oldConfigDirPath);
    }

    // Get the main form
    var form = configForm['form'];

    // Set title and description
    _formModel.setTitle(form['title']);
    _formModel.setDescription(form['description']);

    // Get fields
    var fields = form['fields'];

    // Cycle through all fields
    for (var field in fields) {
      // Get field key (name of the field)
      for (var fieldName in field.keys) {
        // Retrieve field attributes
        var attributes = field[fieldName];

        // Add the final field to the form based on its type
        MosaicoField mosaicoField;
        switch (attributes['type']) {
          case 'string':
            mosaicoField = MosaicoStringField();
            break;
          case 'string[]':
            mosaicoField = MosaicoStringListField();
            break;
          case 'text':
            throw Exception('Text field not implemented yet');
            break;
          case 'checkbox':
            throw Exception('Checkbox field not implemented yet');
            break;
          case 'image':
            mosaicoField = MosaicoImageField();
            break;
          case 'animation':
            throw Exception('Animation field not implemented yet');
            break;
          default:
            throw Exception('Unknown field type: ${attributes['type']}');
        }

        // Add common attributes
        _addComponentAttributes(mosaicoField, attributes, fieldName);

        // Add the field to the form
        _formModel.addField(mosaicoField);
      }
    }
  }


  DynamicFormState buildFormModel() {
    return _formModel;
  }

}
