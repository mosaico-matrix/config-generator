import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mosaico_flutter_core/mosaico_core.dart';
import 'package:mosaico_flutter_core/widgets/dialogs/text_input_dialog.dart';
import 'package:mosaico_flutter_core/widgets/mobile_size.dart';
import 'package:provider/provider.dart';

import '../components/dynamic_form.dart';
import '../models/config_output.dart';
import '../form_builder.dart';
import '../states/dynamic_form_state.dart';

/**
 * This is the main page of the configuration generator
 * It will create the form state where all the stuff is happening
 * It will create the dynamic_form component where the fields are going to be displayed
 * It will create the button to generate the configuration, close the page and return the result
 */
class ConfigGenerator extends StatelessWidget {

  final Map<String, dynamic> _configForm;
  final String? initialConfigName;
  ConfigGenerator(this._configForm, {Key? key, this.initialConfigName}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    // Create the form based on the JSON provided
    var formModel = FormModelBuilder(_configForm).buildFormModel();
    formModel.setConfigName(initialConfigName ?? "");

    // Trigger config name change after whole widget has been built
    if (initialConfigName == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        showConfigNameDialog(context, formModel);
      });
    }

    // Create page
    return MosaicoCore(
      child: MobileSize(
        child: ChangeNotifierProvider(
          create: (context) => formModel,
          child: Builder(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(Provider.of<DynamicFormState>(context).getConfigName()),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        showConfigNameDialog(context, formModel);
                      },
                    ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {

                    // Get form state
                    var formState = Provider.of<DynamicFormState>(context, listen: false);

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
            }
          ),
        ),
      ),
    );
  }

  void showConfigNameDialog(BuildContext context, DynamicFormState formModel) async {
    await TextInputDialog.show(context, "Configuration name", (String name) {
      formModel.setConfigName(name);
    });
  }
}