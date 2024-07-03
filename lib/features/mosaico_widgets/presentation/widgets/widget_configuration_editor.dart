import 'package:flutter/material.dart';
import '../../../../common/widgets/mosaico_button.dart';
import '../../data/models/mosaico_widget.dart';
import '../../data/models/mosaico_widget_configuration.dart';

class WidgetConfigurationEditor extends StatelessWidget {

  final List<MosaicoWidgetConfiguration> configurations;
  final MosaicoWidget widget;
  WidgetConfigurationEditor({required this.configurations, required this.widget});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Configurations'),
      content: Column(children: [
        ...configurations.map((configuration) {
          return ListTile(
            title: Text(configuration.name),
            onTap: () {
              Navigator.pop(context, configuration);
            },
          );
        }).toList(),

        // Add new configuration button
        Spacer(),
        MosaicoButton(
          onPressed: openConfigurationForm,
        ),
      ]),
    );
  }

  void openConfigurationForm() async {
    var configForm = await WidgetsService.getWidgetConfigurationForm(widgetId: widget.id);
    ConfigOutput? generatedConfig = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ConfigFormPage(configForm, initialConfigName: "TEST"),
      ),
    );

    if (generatedConfig != null) {
      await WidgetConfigurationsService.uploadWidgetConfiguration(
          widgetId: widgetId, configurationName: generatedConfig.getConfigName(), configurationArchivePath:  generatedConfig.exportToArchive());
    } else {
      Toaster.error('Configuration generation cancelled');
    }
  }
}
