import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mosaico_flutter_core/common/widgets/mosaico_button.dart';
import 'package:mosaico_flutter_core/common/widgets/renamable_app_bar.dart';
import 'package:mosaico_flutter_core/core/utils/toaster.dart';
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
  final Map<String, dynamic> _configForm; // Deserialized from config-form.json
  final String? oldConfigDirPath; // Path to the old config directory
  final String?
      initialConfigName; // If set the user will not be prompted for a name
  ConfigFormPage(this._configForm,
      {Key? key, this.initialConfigName, this.oldConfigDirPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create the form based on the JSON provided
    try {
      var formModel = DynamicFormStateBuilder(_configForm, oldConfigDirPath)
          .buildFormModel();

      // Check if provided config name
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
                initialTitle:
                    Provider.of<DynamicFormState>(context).getConfigName(),
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

                  // Check if entered name
                  if (formState.getConfigName().isEmpty) {
                    Toaster.warning(
                        "Please enter a name for the configuration");
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
    } catch (e) {
      return Scaffold(
          body: Center(
              child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("${e.toString()}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, color: Colors.red)),
            const SizedBox(height: 16),
            MosaicoButton(
              text: "Close",
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      )));
    }
  }
}
