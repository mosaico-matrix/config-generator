
import 'package:mosaico_flutter_core/modules/config_form/models/dynamic_form_model.dart';

import 'fields/mosaico_field.dart';
import 'fields/mosaico_text_field.dart';

class FormStateBuilder {
  
  /// The form that is being built
  DynamicFormModel _formModel = DynamicFormModel();


  void _addTextField(String name, Map<String, dynamic> attributes) {
    MosaicoTextField field = MosaicoTextField(name);
    _addComponentAttributes(field, attributes);
    _formModel.addField(field);
  }


  void _addComponentAttributes(
      MosaicoField component, Map<String, dynamic> attributes) {
    component.setLabel(attributes['label']);
    component.setPlaceholder(attributes['placeholder']);
    component.setRequired(attributes['required']);
  }
  
  FormStateBuilder(Map<String, dynamic> json) {
    
    // Get form and fields
    var form = json['form'];

    // Set title and description
    _formModel.setTitle(form['title']);
    _formModel.setDescription(form['description']);

    var fields = form['fields'];

    // Cycle through all fields
    for (var field in fields) {
      
      // Get field key (name of the field)
      for (var fieldName in field.keys) {
    
        // Retrieve field attributes
        var attributes = field[fieldName];

        // Add the final field to the form based on its type
        switch (attributes['type']) {
          case 'text':
            _addTextField(fieldName, attributes);
            break;
          default:
            throw Exception('Unknown field type: ${attributes['type']}');
        }
      }
    }
  }


  DynamicFormModel buildFormModel() {
    return _formModel;
  }

}
