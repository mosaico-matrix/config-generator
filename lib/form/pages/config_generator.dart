import 'package:flutter/material.dart';
import 'package:mosaico_config_generator/form/state/dynamic_form_state.dart';
import 'package:provider/provider.dart';

import '../components/dynamic_form.dart';
import '../config_output.dart';

class ConfigGenerator extends StatelessWidget {

  final String _configFormJson;
  ConfigGenerator(this._configFormJson, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConfigFormState(_configFormJson),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Configuration Generator'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                var formState = Provider.of<ConfigFormState>(context, listen: false);
                var output = ConfigOutput(formState);
                Navigator.of(context).pop(output);
              },
              child: const Icon(Icons.save),
            ),
            body: DynamicForm(),
          );
        }
      ),
    );
  }
}