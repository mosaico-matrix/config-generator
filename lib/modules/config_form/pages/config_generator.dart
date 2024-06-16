import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mosaico_flutter_core/mosaico_core.dart';
import 'package:mosaico_flutter_core/widgets/mobile_size.dart';
import 'package:provider/provider.dart';

import '../components/dynamic_form.dart';
import '../states/config_output.dart';
import '../form_builder.dart';
import '../states/dynamic_form_state.dart';

/**
 * This is the main page of the configuration generator
 * It will create the form state where all the stuff is happening
 * It will create the dynamic_form component where the fields are going to be displayed
 * It will create the button to generate the configuration, close the page and return the result
 */
class ConfigGenerator extends StatelessWidget {

  final String _configFormJson;
  ConfigGenerator(this._configFormJson, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // Create the form based on the JSON provided
    var formModel = FormModelBuilder(_configFormJson).buildFormModel();

    // Create page
    return MosaicoCore(
      child: MobileSize(
        child: ChangeNotifierProvider(
          create: (context) => formModel,
          child: Builder(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Configuration Generator'),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {

                    // Get form state
                    var formState = Provider.of<DynamicFormState>(context, listen: false);

                    // Try to validate the form
                    if (!formState.validate()) {
                      print('Form is not valid');
                      return;
                    }


                    var output = ConfigOutput(formState);
                    Navigator.of(context).pop(output);
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
}