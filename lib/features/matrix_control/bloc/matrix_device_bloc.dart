import 'dart:async';
import 'dart:io';

import 'package:coap/coap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logger/logger.dart';
import 'package:mosaico_flutter_core/core/configuration/coap_config.dart';
import 'package:mosaico_flutter_core/core/configuration/configs.dart';
import 'package:mosaico_flutter_core/core/networking/services/coap/coap_service.dart';
import 'package:mosaico_flutter_core/core/utils/toaster.dart';
import 'package:mosaico_flutter_core/features/matrix_control/bloc/matrix_device_event.dart';
import 'package:mosaico_flutter_core/features/matrix_control/bloc/matrix_device_state.dart';
import 'package:mosaico_flutter_core/features/matrix_control/domain/matrix_ble_service.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/data/repositories/mosaico_widget_configurations_coap_repository.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/data/repositories/mosaico_widgets_coap_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatrixDeviceBloc extends Bloc<MatrixDeviceEvent, MatrixDeviceState> {
  /// Logger
  final logger = Logger(printer: PrettyPrinter());

  /// Repository
  final MosaicoWidgetsCoapRepository widgetsRepository;
  final MosaicoWidgetConfigurationsCoapRepository configurationsRepository;

  MatrixDeviceBloc(
      {required this.widgetsRepository, required this.configurationsRepository})
      : super(MatrixDeviceInitialState()) {
    on<ConnectToMatrixEvent>(_onConnectToMatrix);
    on<UpdateMatrixDeviceStateEvent>(_onUpdateMatrixDeviceState);
    on<PingMatrixAndRefreshActiveWidgetEvent>(
        _onPingMatrixAndRefreshActiveWidget);
  }

  Future<void> _onUpdateMatrixDeviceState(UpdateMatrixDeviceStateEvent event,
      Emitter<MatrixDeviceState> emit) async {
    emit(event.newState);
  }

  Future<void> _onPingMatrixAndRefreshActiveWidget(
      PingMatrixAndRefreshActiveWidgetEvent event,
      Emitter<MatrixDeviceState> emit) async {
    // Get active widget
    try {
      var result = await widgetsRepository.getActiveWidget();
      emit(MatrixDeviceConnectedState(
          address: event.previousState.address,
          activeWidget: result.$1,
          activeWidgetConfiguration: result.$2));
    } catch (e) {
      emit(MatrixDeviceDisconnectedState(bleConnected: _bleDeviceConnected()));
    }
  }

  Future<void> _onConnectToMatrix(
      ConnectToMatrixEvent event, Emitter<MatrixDeviceState> emit) async {
    // Start connection
    logger.i('Checking connection status');
    emit(MatrixDeviceConnectingState());

    // Check if user provided a manual address for matrix
    if (event.address != null) {
      // Save the address to the preferences as the new default
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('matrixIp', event.address!);
    }

    // Try to get matrix IP
    var matrixAddress = event.address ?? await _autoGetMatrixIp();

    // Could not get the matrix IP or Matrix is not reachable, try with BLE
    // We only try with ble if user didn't explicitly provide an address
    if (event.address == null &&
        (matrixAddress == null ||
            await CoapService.pingMatrix(matrixAddress) == false)) {
      // Failed to connect via COAP, try BLE
      var bleConnected = _bleDeviceConnected();
      if (!bleConnected) {
        await _searchAndConnectBleDevice();
        bleConnected = _bleDeviceConnected();
      }

      // Notify user of ble status
      if (state is! MatrixDeviceConnectedState) {
        emit(MatrixDeviceDisconnectedState(bleConnected: bleConnected));
        if (!bleConnected) {
          // Nothing left to be done, we failed without a matrix IP
          return;
        }
      } else {
        // WTF are we still checking, we are already connected
        // BTW this can happen if the user manually connects to the matrix while we were previously checking
        return;
      }

      // Check if now we have the matrix IP via BLE
      matrixAddress = await _autoGetMatrixIp();
    }

    // If we still don't have the matrix IP, we failed
    if (matrixAddress == null) {
      if (state is! MatrixDeviceConnectedState) {
        emit(
            MatrixDeviceDisconnectedState(bleConnected: _bleDeviceConnected()));
      }
      return;
    }

    // We are connected now!
    widgetsRepository.clearCache(); // We could be connected to new matrix
    configurationsRepository
        .clearCache(); // We could be connected to new matrix
    emit(MatrixDeviceConnectedState(address: matrixAddress));
    CoapService.setMatrixIp(matrixAddress);

    // Try getting the active widget
    try {
      var result = await widgetsRepository.getActiveWidget();
      emit(MatrixDeviceConnectedState(
          address: matrixAddress,
          activeWidget: result.$1,
          activeWidgetConfiguration: result.$2));
    } catch (e) {
      Toaster.error("Failed to get active widget");
    }
  }

  /// Tries to get the matrix IP from the preferences, with BLE characteristics or the debug IP
  Future<String?> _autoGetMatrixIp() async {
    // Preferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Try to get the matrix IP from the preferences
    var lastKnownMatrixIp = prefs.getString('matrixIp');
    if (lastKnownMatrixIp != null &&
        await CoapService.pingMatrix(lastKnownMatrixIp))
      return lastKnownMatrixIp;

    // IP from settings did not work, try with BLE
    if (!_bleDeviceConnected()) {
      await _searchAndConnectBleDevice();
    }
    try {
      ensureBleDeviceConnected();
      var ipFromBle = await _matrixBleService.getMatrixIp(_connectedMatrix!);
      if (ipFromBle != null && await CoapService.pingMatrix(ipFromBle)) {
        prefs.setString('matrixIp', ipFromBle);
        return ipFromBle;
      }
    } catch (e) {
      logger.e('BLE connection failed');
    }

    // As final resort, use the debug IP
    if (await CoapService.pingMatrix(Configs.debugMatrixIp)) {
      prefs.setString('matrixIp', Configs.debugMatrixIp);
      return Configs.debugMatrixIp;
    }

    return null;
  }

  /*
  * BLE
  */
  static const String SERVICE_NAME =
      "PixelForge"; // Friendly name of the matrix
  static BluetoothDevice? _connectedMatrix;
  final MatrixBleService _matrixBleService = MatrixBleService();

  void _onMatrixDisconnected(BluetoothConnectionState state) async {
    if (state == BluetoothConnectionState.disconnected) {
      //Toaster.error("Matrix disconnected");
      logger.d("Matrix disconnected");
      _connectedMatrix = null;
    }
  }

  Future<void> _onMatrixConnected(BluetoothDevice device) async {
    //Toaster.success("Connected to matrix");
    logger.d("Matrix found: ${device.advName}");

    // Connect to device and stop scanning
    _connectedMatrix = device;
    FlutterBluePlus.stopScan();
    logger.d("Connected to matrix");

    // listen for disconnection
    var subscription = device.connectionState.listen(_onMatrixDisconnected);
    device.cancelWhenDisconnected(subscription, delayed: true, next: true);
  }

  Future<void> _onDeviceFound(List<ScanResult> results) async {
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
      if (service.uuid == Configs.mosaicoBLEServiceUUID) {
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
  static bool _bleDeviceConnected() {
    return _connectedMatrix != null && _connectedMatrix!.isConnected;
  }

  /// Send raw data to the matrix
  static Future<void> sendMatrixRawData(List<int> data) async {
    if (_bleDeviceConnected() == false) {
      Toaster.error("Trying to send data to a disconnected matrix");
      return;
    }

    // Check if data is longer than MTU
    if (data.length > _connectedMatrix!.mtuNow - 3) {
      Toaster.error("Data is too long for the matrix");
      return;
    }
  }

  static void ensureBleDeviceConnected() async {
    if (_bleDeviceConnected() == false) {
      throw Exception("Matrix is not connected");
    }
  }

  static BluetoothDevice getConnectedMatrixBleDevice() {
    return _connectedMatrix == null
        ? throw Exception("Matrix is not connected")
        : _connectedMatrix!;
  }

  // Start scanning for the matrix and connect to it if found
  // This function is asynchronous and returns when the matrix is connected or the scan times out
  Future<void> _searchAndConnectBleDevice() async {
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
      //Toaster.error("Bluetooth is turned off");
      return;
    }

    // Subscription to scan for devices
    var scanSubscription = FlutterBluePlus.onScanResults.listen(_onDeviceFound);

    // cleanup: cancel subscription when scanning stops
    FlutterBluePlus.cancelWhenScanComplete(scanSubscription);

    // Start scanning w/ timeout
    await FlutterBluePlus.startScan(
        //withNames: [SERVICE_NAME],
        withServices: [Configs.mosaicoBLEServiceUUID],
        timeout: const Duration(seconds: 15));

    // Wait for scan until end
    await FlutterBluePlus.isScanning
        .where((isScanning) => isScanning == false)
        .first;
  }
}
