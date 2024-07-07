import 'dart:convert';
import 'dart:io';
import 'package:mosaico_flutter_core/features/mosaico_widgets/data/models/mosaico_widget_configuration.dart';
import '../../../../core/networking/services/coap/coap_service.dart';
import '../../domain/repositories/mosaico_widget_configurations_repository.dart';

class MosaicoWidgetConfigurationsCoapRepository implements MosaicoWidgetConfigurationsRepository {

  @override
  Future<MosaicoWidgetConfiguration> uploadWidgetConfiguration({required int widgetId, required String configurationName, required String configurationArchivePath}) async {

    // Convert the configuration file to base64
    final file = File(configurationArchivePath);
    final fileBase64 = base64Encode(await file.readAsBytes());

    // Send the configuration to the matrix
    var result = await CoapService.post('/widget_configurations/widget_id=$widgetId', '$configurationName,$fileBase64');
    return MosaicoWidgetConfiguration.fromJson(result);
  }

  @override
  Future<List<MosaicoWidgetConfiguration>> getWidgetConfigurations({required int widgetId}) async {
    final response = await CoapService.get('/widget_configurations/widget_id=$widgetId');
    return (response as List).map((e) => MosaicoWidgetConfiguration.fromJson(e)).toList();
  }

  @override
  Future<void> deleteWidgetConfiguration({required int configurationId}) async {
    await CoapService.delete('/widget_configurations/configuration_id=$configurationId');
  }
}
