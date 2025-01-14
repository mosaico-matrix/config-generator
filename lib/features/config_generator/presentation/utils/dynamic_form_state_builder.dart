import 'dart:convert';
import 'package:mosaico_flutter_core/features/config_generator/presentation/widgets/fields/mosaico_color_field.dart';
import 'package:mosaico_flutter_core/features/config_generator/presentation/widgets/fields/mosaico_image_field.dart';
import 'package:mosaico_flutter_core/features/config_generator/presentation/widgets/fields/mosaico_select_field.dart';
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

  DynamicFormStateBuilder(
      Map<String, dynamic> configForm, String? oldConfigDirPath) {
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
          case 'image':
            mosaicoField = MosaicoImageField();
            if (attributes['dimensions'] != null) {
              var dimensions = attributes['dimensions'];
              (mosaicoField as MosaicoImageField)
                  .getState()
                  .setDimensions(dimensions['width'], dimensions['height']);
            }
            break;
          case 'select':
            mosaicoField = MosaicoSelectField();
            (mosaicoField as MosaicoSelectField).getState().setOptions(
                (attributes['options'] as List<dynamic>).cast<String>());
            break;
          case 'font':
            mosaicoField = MosaicoSelectField();
            (mosaicoField as MosaicoSelectField).getState().setOptions([
              '4x6',
              '5x7',
              '5x8',
              '6x9',
              '6x10',
              '6x12',
              '6x13',
              '7x13',
              '7x14',
              '8x13',
              '9x15',
              '9x18',
              '10x20',
              'clR6x12',
              '7x14B',
              '9x15B',
              'texgyre-27',
              '8x13O',
              '7x13B',
              '9x18B',
              '6x13O',
              'tom-thumb',
              'helvR12',
              '6x13B',
              '7x13O',
              '8x13B'
            ]);
          case 'color':
            mosaicoField = MosaicoColorField();
            break;
          case 'text':
            throw Exception('Text field not implemented yet');
            break;
          case 'checkbox':
            throw Exception('Checkbox field not implemented yet');
            break;
          case 'animation':
            throw Exception('Animation field not implemented yet');
            break;
          default:
            throw Exception(
                'Unknown field type: ${attributes['type']}, try to update the to support this type of field');
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
