import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'base_service.dart';

class MatrixService extends BaseService
{
  // Characteristic UUIDs
  static Guid WIFI_CREDENTIALS = Guid("");

  /// Get the service required by this class
  static BluetoothService matrixBluetoothService()
  {
    return BaseService.getService(Guid("d34fdcd0-83dd-4abe-9c16-1230e89ad2f2"));
  }
}