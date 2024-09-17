import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:mosaico_flutter_core/core/exceptions/exception_handler.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/data/models/mosaico_widget_configuration.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/networking/services/coap/coap_service.dart';

class MosaicoWidgetConfigurationsCoapRepository {
  // In-memory cache for widget configurations
  final Map<int, List<MosaicoWidgetConfiguration>> _configurationsCache = {};
  final Map<int, String> _packageCache = {};

  Future<MosaicoWidgetConfiguration> uploadWidgetConfiguration({
    required int widgetId,
    required String configurationName,
    required String configurationArchivePath
  }) async {
    final file = File(configurationArchivePath);
    final fileBase64 = base64Encode(await file.readAsBytes());

    var result = await CoapService.post('/widget_configurations/widget_id=$widgetId', '$configurationName,$fileBase64');
    var configuration =  MosaicoWidgetConfiguration.fromJson(result);

    // Add to cache
    if (!_configurationsCache.containsKey(widgetId)) {
      _configurationsCache[widgetId] = [];
    }
    _configurationsCache[widgetId]!.add(configuration);

    return configuration;
  }

  Future<MosaicoWidgetConfiguration> updateWidgetConfiguration({
    required int configurationId,
    required String configurationName,
    required String configurationArchivePath
  }) async {
    final file = File(configurationArchivePath);
    final fileBase64 = base64Encode(await file.readAsBytes());

    var result = await CoapService.post('/widget_configurations/configuration_id=$configurationId', '$configurationName,$fileBase64');
    var configuration = MosaicoWidgetConfiguration.fromJson(result);

    // Find this configuration in the cache and update it
    _configurationsCache.forEach((key, value) {
      var index = value.indexWhere((element) => element.id == configurationId);
      if (index != -1) {
        _configurationsCache[key]![index] = configuration;
      }
    });

    return configuration;
  }

  Future<List<MosaicoWidgetConfiguration>> getWidgetConfigurations({required int widgetId}) async {
    // Check if configurations are cached
    if (_configurationsCache.containsKey(widgetId)) {
      return _configurationsCache[widgetId]!;
    }

    // Fetch configurations from the service
    final response = await CoapService.get('/widget_configurations/widget_id=$widgetId');
    final configurations = (response as List).map((e) => MosaicoWidgetConfiguration.fromJson(e)).toList();

    // Cache the configurations
    _configurationsCache[widgetId] = configurations;
    return configurations;
  }


  Future<bool> isWidgetConfigurable({required int widgetId}) async {
    final configurations = await getWidgetConfigurations(widgetId: widgetId);
    return configurations.isNotEmpty;
  }

  Future<void> deleteWidgetConfiguration({required int configurationId}) async {
    await CoapService.delete('/widget_configurations/configuration_id=$configurationId');

    // Optionally clear cache for configurations if needed
    _configurationsCache.removeWhere((key, value) =>
        value.any((config) => config.id == configurationId)
    );
  }

  Future<String> getWidgetConfigurationPackage({required int configurationId}) async {
    // Check if package is cached
    if (_packageCache.containsKey(configurationId)) {
      return _packageCache[configurationId]!;
    }

    var package = await CoapService.get('/widget_configurations/package/configuration_id=$configurationId');

    var tempDir = await getTemporaryDirectory();
    var folder = Directory(tempDir.path + '/widgetConfigurations');
    await folder.create();
    var path = folder.path + '/package.tar.gz';
    var file = File(path);
    await file.writeAsBytes(base64Decode(package));

    var archive = TarDecoder().decodeBytes(GZipDecoder().decodeBytes(file.readAsBytesSync()));

    for (var file in archive) {
      var filename = folder.path + '/' + file.name;

      if (file.isFile) {
        var newFile = File(filename);
        newFile.createSync(recursive: true);
        newFile.writeAsBytesSync(file.content as List<int>);
      } else {
        var newDir = Directory(filename);
        newDir.createSync(recursive: true);
      }
    }

    await file.delete();

    // Cache the package path
    _packageCache[configurationId] = folder.path;
    return folder.path;
  }

  // Method to clear the cache
  void clearCache() {
    _configurationsCache.clear();
    _packageCache.clear();
  }
}
