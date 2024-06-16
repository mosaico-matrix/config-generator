import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:mosaico_flutter_core/toaster.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class ConfigOutput {

  late final String _tempPath;
  late final String _dataOutputPath;

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
   * Save files to disk in temp folder as they are provided
   */
  void setData(Map<String, dynamic> data) {
    File('$_dataOutputPath/data.json').writeAsStringSync(jsonEncode(data));
  }

  void addImage(String name, File image) {
    image.copySync('$_dataOutputPath/$name.ppm');
  }

  void addAnimation(File animation) {
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
    encoder.open(outputFile.path);

    // Add the contents of the directory to the archive
    encoder.addDirectory(sourceDir, includeDirName: false);

    // Close the archive to finalize the tar.gz file
    encoder.close();
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