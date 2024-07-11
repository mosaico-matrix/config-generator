import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:mosaico_flutter_core/core/exceptions/exception_handler.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/data/models/mosaico_widget_configuration.dart';
import 'package:path_provider/path_provider.dart';
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
  Future<MosaicoWidgetConfiguration> updateWidgetConfiguration({required int configurationId, required String configurationName, required String configurationArchivePath}) async {

      // Convert the configuration file to base64
      final file = File(configurationArchivePath);
      final fileBase64 = base64Encode(await file.readAsBytes());

      // Send the configuration to the matrix
      var result = await CoapService.post('/widget_configurations/configuration_id=$configurationId', '$configurationName,$fileBase64');
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

  @override
  Future<String> getWidgetConfigurationPackage({required int configurationId}) async {
    var package = await CoapService.get('/widget_configurations/package/configuration_id=$configurationId');

    // Write the package to a file in the temp directory
    var tempDir = await getTemporaryDirectory();
    var folder = Directory(tempDir.path + '/widgetConfigurations');
    await folder.create();
    var path = folder.path + '/package.tar.gz';
    var file = File(path);
    await file.writeAsBytes(base64Decode(package));

    // Decompress the package
    var archive = TarDecoder().decodeBytes(GZipDecoder().decodeBytes(file.readAsBytesSync()));

    // Extract the files
    for (var file in archive) {
      var filename = folder.path + '/' + file.name;

      // Check if file or directory
      if (file.isFile) {
        var newFile = File(filename);
        newFile.createSync(recursive: true);
        newFile.writeAsBytesSync(file.content as List<int>);
      } else {
        var newDir = Directory(filename);
        newDir.createSync(recursive: true);
      }


    }

    // Remove the package file
    await file.delete();

    return folder.path;
  }

}
