
import 'package:flutter/material.dart';
import 'package:mosaico_flutter_core/features/config_generator/presentation/states/fields/mosaico_field_state.dart';
import 'package:provider/provider.dart';

import '../../states/dynamic_form_state.dart';

abstract class MosaicoField<T extends MosaicoFieldState> extends StatelessWidget {

  final T state;
  const MosaicoField({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
        create: (context) => state,
        child:Builder(
          builder: (context) {

            // Get dynamic form state to init with edit value
            var dynamicFormState = Provider.of<DynamicFormState>(context, listen: false);
            state.init(dynamicFormState.getEditValue(state.getName()));

            return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildField(context),
                  );
          }
        )
    );
  }

  Widget buildField(BuildContext context);

  T getState() {
    return state;
  }
}