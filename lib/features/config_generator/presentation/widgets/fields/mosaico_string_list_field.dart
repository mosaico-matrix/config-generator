import 'package:coap/builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../states/dynamic_form_state.dart';
import '../../states/fields/mosaico_field_state.dart';
import 'mosaico_field.dart';

class MosaicoStringListField extends MosaicoField<MosaicoStringListFieldState> {

  MosaicoStringListField() : super(fieldState: MosaicoStringListFieldState());

  @override
  Widget buildField(BuildContext context) {
    return Consumer<MosaicoStringListFieldState>(
      builder: (context, stringListState, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < stringListState.values.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(
                            text: stringListState.values[i]),
                        onChanged: (value) =>
                            stringListState.updateValue(i, value),
                        decoration: InputDecoration(
                          hintText: 'Enter ${stringListState.getPlaceholder()}',
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
              ),
            Center(
              child: IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: stringListState.addValue,
              ),
            ),
          ],
        );
      }
    );
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
  void init(oldValue) {
    _values = (oldValue is List<dynamic>) ? List<String>.from(oldValue) : [''];
    notifyListeners();
  }

  @override
  getAsset() {
    return null; // we don't need to save an asset
  }

  @override
  String? validate() {
    return _values.any((element) => element.isNotEmpty) || !isRequired()
        ? null
        : 'This field is required';
  }

  @override
  getData() {
    return _values;
  }
}
