import 'package:coap/builder.dart';
import 'package:flutter/material.dart';
import 'package:mosaico_flutter_core/features/config_generator/presentation/states/fields/mosaico_field_state.dart';
import 'package:provider/provider.dart';

import '../../states/dynamic_form_state.dart';

/// This is a wrapper around each field
/// Cannot be used with compositing but with inheritance since we need to hold a list of type [MosaicoField] inside [DynamicFormState]
/// This class holds the state of the child field needed later to retrieve field values
abstract class MosaicoField<T extends MosaicoFieldState>
    extends StatelessWidget {
  final T fieldState;

  const MosaicoField({super.key, required this.fieldState});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ChangeNotifierProvider<T>(
          create: (context) => fieldState,
          child: Builder(builder: (context) {
            // Get dynamic form state to init with edit value
            var dynamicFormState =
                Provider.of<DynamicFormState>(context, listen: false);
            fieldState
                .init(dynamicFormState.getEditValue(fieldState.getName()));

            // Create form field
            return FormField(
                validator: (value) {
              return fieldState.validate();
            }, builder: (FormFieldState formFieldState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fieldState.getLabel().capitalize(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Visibility(
                    visible: formFieldState.errorText != null,
                    child: Text(
                      formFieldState.errorText ?? '',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: formFieldState.errorText != null ? Theme.of(context).colorScheme.error : Colors.white),
                      //borderRadius: BorderRadius.circular(4),
                    ),
                    child: buildField(context),
                  ),
                ],
              );
            });
          })),
    );
  }

  Widget buildField(BuildContext context);

  T getState() {
    return fieldState;
  }
}
