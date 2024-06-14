import 'components/component.dart';
import 'components/text_input.dart';

class ConfigForm {
  final List<Component> components = [];
  final String jsonContent;


  /// Parses the given JSON string and creates a new [ConfigurationParser] object.
  ConfigForm(this.jsonContent) {
    var component = TextInput('first_name');
    addComponentAttributes(component, {'label': 'First Name'});
    components.add(component);
  }

  void addComponentAttributes(Component component, Map<String, dynamic> attributes)
  {
    component.setLabel(attributes['label']);
  }
}