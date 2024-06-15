
import 'fields/mosaico_field.dart';
import 'fields/mosaico_text_field.dart';
import 'form.dart';

class FormBuilder {
  
  /// The form that is being built
  Form _form = Form();


  void _addTextField(String name, Map<String, dynamic> attributes) {
    MosaicoTextField field = MosaicoTextField(name);
    _addComponentAttributes(field, attributes);
    _form.addField(field);
  }


  void _addComponentAttributes(
      MosaicoField component, Map<String, dynamic> attributes) {
    component.setLabel(attributes['label']);
  }
  
  FormBuilder(Map<String, dynamic> json) {
    
    // Get form and fields
    var form = json['form'];
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


  Form buildForm() {
    return _form;
  }

}
