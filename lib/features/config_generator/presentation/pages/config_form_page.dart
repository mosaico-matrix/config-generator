import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mosaico_flutter_core/common/widgets/renamable_app_bar.dart';
import 'package:provider/provider.dart';
import '../../../../common/widgets/dialogs/text_input_dialog.dart';
import '../../../../common/widgets/mobile_size.dart';
import '../states/dynamic_form_state.dart';
import '../utils/dynamic_form_state_builder.dart';
import '../widgets/dynamic_form.dart';

/**
 * This is the main page of the configuration generator
 * It will create the form state where all the stuff is happening
 * It will create the dynamic_form component where the fields are going to be displayed
 * It will create the button to generate the configuration, close the page and return the result
 */
class ConfigFormPage extends StatelessWidget {
  final Map<String, dynamic> _configForm;
  final String? initialConfigName;

  ConfigFormPage(this._configForm, {Key? key, this.initialConfigName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    // Create the form based on the JSON provided
    var formModel = DynamicFormStateBuilder(_configForm).buildFormModel();
    formModel.setConfigName(initialConfigName ?? "");

    // Create page
    return MobileSize(
      child: ChangeNotifierProvider(
        create: (context) => formModel,
        child: Builder(builder: (context) {
          return Scaffold(
            appBar: RenamableAppBar(
              promptText: "Enter configuration name",
              askOnLoad: initialConfigName == null,
              initialTitle: Provider.of<DynamicFormState>(context).getConfigName(),
              onTitleChanged: (String newName) {
                Provider.of<DynamicFormState>(context, listen: false)
                    .setConfigName(newName);
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                // Get form state
                var formState =
                    Provider.of<DynamicFormState>(context, listen: false);

                // Try to validate the form
                if (!formState.validate()) {
                  return;
                }

                // Get output model with all the needed data
                Navigator.of(context).pop(await formState.export());
              },
              child: const Icon(Icons.save),
            ),
            body: DynamicForm(),
          );
        }),
      ),
    );
  }
}
