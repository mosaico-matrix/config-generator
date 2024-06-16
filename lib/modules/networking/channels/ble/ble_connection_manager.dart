import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logger/logger.dart';
import 'package:mosaico_flutter_core/toaster.dart';

class BLEConnectionManager {

  static const String SERVICE_NAME = "PixelForge"; // Friendly name of the matrix
  static Guid MATRIX_WELCOME_SERVICE_UUID = Guid("d34fdcd0-83dd-4abe-9c16-1230e89ad2f2"); // Service UUID to look for
  static BluetoothDevice? _connectedMatrix;

  static final logger = Logger(
    printer: PrettyPrinter(),
  );

  static void _onMatrixDisconnected(BluetoothConnectionState state) async {
    if (state == BluetoothConnectionState.disconnected) {
      Toaster.error("Matrix disconnected");
      logger.d("Matrix disconnected");
      _connectedMatrix = null;
    }
  }

  static Future<void> _onMatrixConnected(BluetoothDevice device) async
  {
    Toaster.success("Connected to matrix");
    logger.d("Matrix found: ${device.advName}");

    // Connect to device and stop scanning
    _connectedMatrix = device;
    FlutterBluePlus.stopScan();
    logger.d("Connected to matrix");


    // listen for disconnection
    var subscription = device.connectionState.listen(_onMatrixDisconnected);
    device.cancelWhenDisconnected(subscription, delayed:true, next:true);
  }

  static Future<void> _onDeviceFound(List<ScanResult> results) async {

    if (results.isEmpty) {
      return;
    }

    // Get last discovered device
    var device = results.last.device;
    await device.connect(timeout: const Duration(seconds: 10));
    logger.d("Found device: ${device.remoteId}, ${device.advName}");

    // Discover services of the device
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      logger.d("Device is offering service: ${service.uuid}");

      // Search for the service we are interested in
      if (service.uuid == MATRIX_WELCOME_SERVICE_UUID) {

        logger.d("Found the service we are looking for, hello matrix!");

        // Found the service, connect to the device
        _onMatrixConnected(device);
      }
    }

    // Device is not the one we are looking for
    if (_connectedMatrix == null) {
      logger.d("Device is not the matrix we are looking for");
      await device.disconnect();
    }
  }

  /// Check if the matrix is connected and ready to receive data
  static bool matrixConnected() {
    return _connectedMatrix != null && _connectedMatrix!.isConnected;
  }

  /// Send raw data to the matrix
  static Future<void> sendMatrixRawData(List<int> data) async {
     if (matrixConnected() == false) {
       Toaster.error("Trying to send data to a disconnected matrix");
       return;
     }

    // Check if data is longer than MTU
    if (data.length > _connectedMatrix!.mtuNow - 3) {
      Toaster.error("Data is too long for the matrix");
      return;
    }
  }

  static void ensureMatrixConnected() async {
    if (matrixConnected() == false) {
      throw Exception("Matrix is not connected");
    }
  }

  static BluetoothDevice getConnectedMatrix() {
    return _connectedMatrix == null ? throw Exception("Matrix is not connected") : _connectedMatrix!;
  }

  // Start scanning for the matrix and connect to it if found
  // This function is asynchronous and returns when the matrix is connected or the scan times out
  static Future<void> searchAndConnectMatrix() async {


    // Check if Bluetooth is supported
    if (await FlutterBluePlus.isSupported == false) {
      Toaster.error("Bluetooth is not supported on this device");
      return;
    }

    // On Android, we can request to turn on Bluetooth
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }

    // Wait for Bluetooth enabled & permission granted
    var bluetoothState = await FlutterBluePlus.adapterState.first;
    if (bluetoothState != BluetoothAdapterState.on) {
      Toaster.error("Bluetooth is turned off");
      return;
    }

    // Subscription to scan for devices
    var scanSubscription = FlutterBluePlus.onScanResults.listen(_onDeviceFound);

    // cleanup: cancel subscription when scanning stops
    FlutterBluePlus.cancelWhenScanComplete(scanSubscription);

    // Start scanning w/ timeout
    await FlutterBluePlus.startScan(
        //withNames: [SERVICE_NAME],
        withServices: [MATRIX_WELCOME_SERVICE_UUID],
        timeout: const Duration(seconds: 15));

    // Wait for scan until end
    await FlutterBluePlus.isScanning
        .where((isScanning) => isScanning == false)
        .first;
  }
}
