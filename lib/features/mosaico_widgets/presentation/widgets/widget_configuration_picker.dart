import 'package:flutter/material.dart';

import '../../data/models/mosaico_widget_configuration.dart';

class WidgetConfigurationPicker extends StatelessWidget {

  final List<MosaicoWidgetConfiguration> configurations;
  WidgetConfigurationPicker({required this.configurations});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select a configuration'),
      content: Column(
        children: configurations.map((configuration) {
          return ListTile(
            title: Text(configuration.name),
            onTap: () {
              Navigator.pop(context, configuration);
            },
          );
        }).toList(),
      ),
    );
  }
}
