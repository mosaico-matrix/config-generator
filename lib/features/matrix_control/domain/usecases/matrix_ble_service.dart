import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mosaico_flutter_core/core/networking/services/ble/ble_connection_manager.dart';


class MatrixBle
{
  // Characteristic UUIDs
  static Guid WIFI_CREDENTIALS = Guid("9d0e35da-bc0f-473e-a32c-25d33eaae17b");
  static Guid LOCAL_IP = Guid("9d0e35da-bc0f-473e-a32c-25d33eaae17c");

  /// Get matrix ip
  static Future<String?> getMatrixIp() async
  {
    var characteristic = BLEConnectionManager.getService().getCharacteristic(LOCAL_IP);
    List<int> value = await characteristic.read();
    return String.fromCharCodes(value);
  }

}


extension FindCharacteristic on BluetoothService {

  BluetoothCharacteristic getCharacteristic(Guid requestedCharacteristic) {
    // Get requested service
    var service = this;

    // Get requested characteristic
    for (var characteristic in service.characteristics) {
      if (characteristic.uuid.str128 == requestedCharacteristic.toString()) {
        return characteristic;
      }
    }

    throw Exception("Characteristic not found");
  }
}


