import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class ConfigOutput {

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  late final String _tempPath;
  late final String _dataOutputPath;
  late final String _configName;

  /// Initialize the _tempPath
  /// CALL THIS BEFORE SETTING ANYTHING!
  Future<void> initialize() async {

    // Create temp path
    Directory tempDir = await getTemporaryDirectory();
    _tempPath = tempDir.path + "/config_output";
    _dataOutputPath = _tempPath + "/data";

    // Delete previous files
    await deleteTempFiles();

    // Create new directories
    Directory(_tempPath).createSync();
    Directory(_dataOutputPath).createSync();
  }

  /**
   * Configuration name
   */
  void setConfigName(String name) {
    _configName = name;
  }
  String getConfigName() {
    return _configName;
  }

  /**
   * Save files to disk in temp folder as they are provided
   */
  void saveConfigScript(String script) {
    File('$_dataOutputPath/config.chai').writeAsStringSync(script);
  }

  /**
   * Export everything
   */

  /// Exports the created directory with config files to a .tar.gz archive
  /// Returns the path to the archive
  String exportToArchive() {

    // Define the source directory and the output file
    final sourceDir = Directory(_dataOutputPath);
    final outputFile = File('$_tempPath/config.tar.gz');

    // Create an archive
    final encoder = TarFileEncoder();
    encoder.open('$_tempPath/config.tar');

    // Add the contents of the directory to the archive
    encoder.addDirectory(sourceDir, includeDirName: false);

    // Close the archive to finalize the tar file
    encoder.close();

    // Read the tar file
    final tarFile = File('$_tempPath/config.tar');
    final tarBytes = tarFile.readAsBytesSync();

    // Compress the tar file using gzip
    final gzBytes = GZipEncoder().encode(tarBytes);

    // Write the compressed file to disk
    outputFile.writeAsBytesSync(gzBytes!);

    // Optionally delete the intermediate tar file
    tarFile.deleteSync();

    logger.d('Exported config to: ${outputFile.path}');
    return outputFile.path;
  }

  Future deleteTempFiles() async {
    try
    {
      await Directory(_tempPath).delete(recursive: true);
    }catch(ex)
    {
      // whatever
    }
  }
}