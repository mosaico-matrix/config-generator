import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../form/config_form.dart';

class ConfigGenerator extends StatelessWidget
{
  final ConfigForm form;
  const ConfigGenerator(this.form, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: Icon(Icons.save)
      ),
      body: Center(

        // Render list of widgets in configuration
        child: Column(
          children: [
            Text(form.components.length.toString()),
            // configurationParser.
          ],
        ),
      ),
    );
  }

}