import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mosaico_flutter_core/core/configuration/configs.dart';
import 'package:mosaico_flutter_core/core/networking/services/ble/ble_connection_manager.dart';

class MatrixBleService {

  // Characteristic UUIDs
  static Guid WIFI_CREDENTIALS = Guid("9d0e35da-bc0f-473e-a32c-25d33eaae17b");
  static Guid LOCAL_IP = Guid("9d0e35da-bc0f-473e-a32c-25d33eaae17c");


  /// Get matrix ip
  Future<String?> getMatrixIp(BluetoothDevice device) async {
    var characteristic =
        getCharacteristic(device, Configs.mosaicoBLEServiceUUID, LOCAL_IP);
    List<int> value = await characteristic.read();
    return String.fromCharCodes(value);
  }

  /// Send network credentials
  Future<void> sendNetworkCredentials(
      BluetoothDevice device, String ssid, String password) async {
    var characteristic = getCharacteristic(
        device, Configs.mosaicoBLEServiceUUID, WIFI_CREDENTIALS);

    // Make ssid|password string
    var credentials = "$ssid|$password";
    await characteristic.write(credentials.codeUnits);
  }
}

BluetoothCharacteristic getCharacteristic(BluetoothDevice device,
    Guid requestedService, Guid requestedCharacteristic) {

  // Get requested service
  var service = device.servicesList
      .where((service) => service.uuid.str128 == requestedService.toString())
      .first;

  // Get requested characteristic
  for (var characteristic in service.characteristics) {
    if (characteristic.uuid.str128 == requestedCharacteristic.toString()) {
      return characteristic;
    }
  }

  throw Exception("Characteristic not found");
}
