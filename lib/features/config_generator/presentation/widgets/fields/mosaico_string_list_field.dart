import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../states/dynamic_form_state.dart';
import 'mosaico_field.dart';

class MosaicoStringListField extends MosaicoField {
  final String name;

  MosaicoStringListField(this.name, {Key? key}) : super(name, key: key);

  @override
  Widget buildField(BuildContext context, DynamicFormState state) {
    return ChangeNotifierProvider<StringListState>(
      create: (_) => StringListState(
        DynamicFormState().getEditValue(name) ?? [],
      ),
      child: Consumer<StringListState>(
        builder: (context, state, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
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
                    for (int i = 0; i < state.values.length; i++)
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: TextEditingController(text: state.values[i]),
                              onChanged: (value) => state.updateValue(i, value),
                              decoration: InputDecoration(
                                labelText: '$name ${i + 1}', // Display label with index
                                hintText: 'Enter ${name.toLowerCase()}',
                                hintStyle: TextStyle(color: Color(0xFFCCCCCC)),
                                fillColor: Colors.transparent,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_circle),
                            onPressed: () => state.removeValue(i),
                          ),
                        ],
                      ),
                    Center(
                      child: IconButton(
                        icon: Icon(Icons.add_circle),
                        onPressed: state.addValue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  getConfigScriptData() {

  }

  @override
  String getConfigScriptLine() {
    return '';
  }


}

// ChangeNotifier for managing state
class StringListState extends ChangeNotifier {
  List<String> _values = ['a', 'b', 'c'];

  List<String> get values => _values;

  StringListState(List<String> initialValues) {
    //_values = initialValues;
  }

  void updateValue(int index, String value) {
    _values[index] = value;
    notifyListeners(); // Notify listeners of state change
  }

  void addValue() {
    _values.add('');
    notifyListeners(); // Notify listeners of state change
  }

  void removeValue(int index) {
    _values.removeAt(index);
    notifyListeners(); // Notify listeners of state change
  }
}
