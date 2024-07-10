import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../states/dynamic_form_state.dart';

abstract class MosaicoField<FieldState extends MosaicoFieldState>
    extends StatelessWidget {
  final FieldState mosaicoFieldState;
  MosaicoField({Key? key, required this.mosaicoFieldState, required name}) : super(key: key) {
    mosaicoFieldState.setName(name);
    mosaicoFieldState.setLabel(name);
  }

  /// This method should return the widget that represents the field
  Widget buildField(BuildContext context, DynamicFormState state);

  @override
  Widget build(BuildContext context) {
    
    // Get global form state
    var formState = Provider.of<DynamicFormState>(context, listen: false);

    // Pass it to the field
    mosaicoFieldState.setFormState(formState);

    // Initialize the field with the old value if it exists
    mosaicoFieldState.init(formState.getEditValue(mosaicoFieldState.getName()));


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ChangeNotifierProvider<FieldState>.value(
        value: mosaicoFieldState,
        child: Builder(
          builder: (context) {
            return buildField(context, formState);
          },
        ),
      ),
    );
  }
}

abstract class MosaicoFieldState extends ChangeNotifier {

  /*
  * Form state passed down to the field
  */
  late DynamicFormState _formState;
  void setFormState(DynamicFormState formState) {
    _formState = formState;
  }
  DynamicFormState getFormState() {
    return _formState;
  }

  /*
  * Basic field stuff
  */
  late String _name = "";
  void setName(String name) {
    _name = name;
  }
  String getName() {
    return _name;
  }

  late String _label;

  void setLabel(String label) {
    _label = label;
  }

  String getLabel() {
    return _label;
  }

  String? _placeholder;

  void setPlaceholder(String placeholder) {
    _placeholder = placeholder;
  }

  String? getPlaceholder() {
    return _placeholder;
  }

  bool _required = false;

  void setRequired(bool required) {
    _required = required;
  }

  bool isRequired() {
    return _required;
  }

  /*
  * Stuff to override
  */

  /// This method should return the script code to run before the widget script is loaded onto the matrix
  String getConfigScriptLine();

  /// This method should save the field data to edit it later
  dynamic saveDataForEdit();

  void init(dynamic oldValue);
}