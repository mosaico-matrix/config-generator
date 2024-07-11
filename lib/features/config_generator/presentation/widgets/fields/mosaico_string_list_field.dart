import 'package:coap/builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../states/dynamic_form_state.dart';
import '../../states/fields/mosaico_field_state.dart';
import 'mosaico_field.dart';

class MosaicoStringListField extends MosaicoField<MosaicoStringListFieldState> {

  MosaicoStringListField() : super(state: MosaicoStringListFieldState());

  @override
  Widget buildField(BuildContext context) {
    return Consumer<MosaicoStringListFieldState>(
      builder: (context, stringListState, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stringListState.getName().capitalize(),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < stringListState.values.length; i++)
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: TextEditingController(text: stringListState.values[i]),
                            onChanged: (value) => stringListState.updateValue(i, value),
                            decoration: InputDecoration(
                              labelText: 'Value ${i + 1}',
                              hintText: 'Enter ${stringListState.getName().toLowerCase()}',
                              hintStyle: TextStyle(color: Color(0xFFCCCCCC)),
                              fillColor: Colors.transparent,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_circle),
                          onPressed: () => stringListState.removeValue(i),
                        ),
                      ],
                    ),
                  Center(
                    child: IconButton(
                      icon: Icon(Icons.add_circle),
                      onPressed: stringListState.addValue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  getConfigScriptData() {}

  @override
  String getConfigScriptLine() {
    return '';
  }
}

// ChangeNotifier for managing state
class MosaicoStringListFieldState extends MosaicoFieldState {
  /*
  * Values
  */
  List<String> _values = [''];
  List<String> get values => _values;
  void updateValue(int index, String value) {
    _values[index] = value;
  }

  void addValue() {
    if (_values.length >= 32) return;
    _values.add('');
    notifyListeners(); // Notify listeners of state change
  }

  void removeValue(int index) {
    if (_values.length == 1) return;
    _values.removeAt(index);
    notifyListeners(); // Notify listeners of state change
  }

  /*
  * Overloaded
  */
  @override
  String getConfigScriptLine() {

    // Create python array
    return '${getName()} = [${_values.map((e) => '"$e"').join(', ')}]';
  }

  @override
  void init(oldValue) {
    _values = (oldValue is List<dynamic>) ? List<String>.from(oldValue) : [''];
    notifyListeners();
  }

  @override
  saveDataForEdit() {
    return _values;
  }
}
