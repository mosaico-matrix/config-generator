import 'dart:convert';
import '../states/dynamic_form_state.dart';
import '../widgets/fields/mosaico_field.dart';
import '../widgets/fields/mosaico_string_field.dart';

class FormModelBuilder {

  /// The form that is being built
  DynamicFormState _formModel = DynamicFormState();


  /// Adds the common attributes to a generic mosaico componet
  void _addComponentAttributes(MosaicoField component, Map<String, dynamic> attributes) {
    component.setLabel(attributes['label']);
    component.setPlaceholder(attributes['placeholder']);
    component.setRequired(attributes['required']);
  }

  FormModelBuilder(Map<String, dynamic> configForm) {

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
            mosaicoField = MosaicoStringField(fieldName);
            break;
          case 'text':
            throw Exception('Text field not implemented yet');
            break;
          case 'checkbox':
            throw Exception('Checkbox field not implemented yet');
            break;
          case 'image':
            throw Exception('Image field not implemented yet');
            break;
          case 'animation':
            throw Exception('Animation field not implemented yet');
            break;
          default:
            throw Exception('Unknown field type: ${attributes['type']}');
        }

        // Add common attributes
        _addComponentAttributes(mosaicoField, attributes);

        // Add the field to the form
        _formModel.addField(mosaicoField);
      }
    }
  }


  DynamicFormState buildFormModel() {
    return _formModel;
  }

}
