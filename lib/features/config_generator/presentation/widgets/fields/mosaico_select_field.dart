import 'package:flutter/material.dart';
import 'package:mosaico_flutter_core/features/config_generator/presentation/states/fields/mosaico_field_state.dart';
import 'package:provider/provider.dart';
import '../../states/dynamic_form_state.dart';
import 'mosaico_field.dart';

class MosaicoSelectField extends MosaicoField<MosaicoSelectFieldState> {
  MosaicoSelectField({Key? key})
      : super(fieldState: new MosaicoSelectFieldState());

  @override
  Widget buildField(BuildContext context) {
    return Consumer<MosaicoSelectFieldState>(
      builder: (context, state, _) {

        // Create options
        var options = state.options.map((String value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }).toList()
          ..insert(0,DropdownMenuItem(
              value: "",
              child: Text(state.getPlaceholder() ?? "Select an option"),
          ));

        return DropdownButtonFormField<String>(
          value: state.value,
          items: options,
          onChanged: (value) {
            state.setValue(value!);
          },
          decoration: InputDecoration(
            hintText: state.getPlaceholder(),
          ),
        );
      },
    );
  }
}

class MosaicoSelectFieldState extends MosaicoFieldState {
  /*
  * Field value
  */
  String _value = "";

  String get value => _value;

  void setValue(String value) {
    _value = value;
  }

  @override
  void init(oldValue) {
    _value = oldValue ?? "";
    notifyListeners();
  }

  @override
  getAsset() {
    return null; // we don't need to save an asset for a select field
  }

  @override
  String? validate() {
    return _value.isNotEmpty || !isRequired() ? null : "You must select an option";
  }

  @override
  getData() {
    return _value;
  }

  List<String> _options = [];

  List<String> get options => _options;

  void setOptions(List<String> options) {
    _options = options;
    notifyListeners();
  }
}
