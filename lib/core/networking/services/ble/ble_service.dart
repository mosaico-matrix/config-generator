import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'ble_connection_manager.dart';

abstract class BaseService {

  /// Get the service with the requested UUID
  /// Throws an exception if the service is not found
  /// Throws an exception if the matrix is not connected
  static BluetoothService getService(Guid requestedService) {
    // Get requested service
    for (var service
        in BLEConnectionManager.getConnectedMatrix().servicesList) {
      if (service.uuid.str128 == requestedService.toString()) {
        return service;
      }
    }

    throw Exception("Service not found");
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