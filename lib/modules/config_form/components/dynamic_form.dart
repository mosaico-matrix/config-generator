import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/dynamic_form_state.dart';

/**
 * This widget is used to display a dynamic form based on the user's configuration
 * It will display the list of fields provided by the dynamic_form_state
 */
class DynamicForm extends StatelessWidget {
  const DynamicForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.black54,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 450),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: ListView(
                children: [

                  // Render form title
                  Text(Provider.of<DynamicFormState>(context).getForm().getTitle()),

                  // Render each field in the form
                  for (var field in Provider.of<DynamicFormState>(context)
                      .getForm()
                      .getFields())
                    field
                ],
              ),
          ),
        ),
      ),
    );
  }
}
