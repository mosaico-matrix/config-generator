import 'dart:async';
import 'dart:io';
import 'package:coap/coap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logger/logger.dart';
import 'package:mosaico_flutter_core/common/widgets/dialogs/text_input_dialog.dart';
import 'package:mosaico_flutter_core/core/configuration/coap_config.dart';
import 'package:mosaico_flutter_core/core/configuration/configs.dart';
import 'package:mosaico_flutter_core/features/matrix_control/domain/usecases/matrix_ble_service.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/data/models/mosaico_widget_configuration.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/data/repositories/mosaico_widgets_coap_repository.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/networking/services/coap/coap_service.dart';
import '../../../../core/utils/toaster.dart';
import '../../../mosaico_loading/presentation/states/mosaico_loading_state.dart';
import '../../../mosaico_widgets/data/models/mosaico_widget.dart';
import '../../../mosaico_widgets/domain/repositories/mosaico_local_widgets_repository.dart';

class MosaicoDeviceState with ChangeNotifier {
  /// Logger
  final logger = Logger(printer: PrettyPrinter());

  /// Repository
  MosaicoWidgetsCoapRepository widgetsRepository =
      MosaicoWidgetsCoapRepository();

  /// Connection status
  bool? _isCoapConnected; // At first we don't know if COAP is connected
  bool? _isBleConnected;  // At first we don't know if BLE is connected

  /// Connecting status
  bool? _isConnecting; // At first we don't know if we are connecting
  bool get isConnecting =>
      _isConnecting ??
      true; // But we assume that we are connecting from outside

  /// We only need to know if the device is connected to COAP, BLE is secondary
  bool get isConnected =>
      _isCoapConnected ??
      false; // At first we don't know if COAP is connected so we assume it's not
  String get coapConnectionStatusText =>
      isConnected ? 'Connected' : (isConnecting ? 'Connecting' : 'Disconnected');

  /// BLE connection status
  String get bleConnectionStatusText => _isBleConnected == true
      ? 'BLE connected'
      : (_isBleConnected == false ? 'BLE disconnected' : 'connecting BLE...');

  /// Device info
  MosaicoWidget? _activeWidget;

  bool get hasActiveWidget => _activeWidget != null;

  String get activeWidgetName => _activeWidget?.name ?? 'n/a';
  MosaicoWidgetConfiguration? _activeWidgetConfiguration;

  String get activeWidgetConfigurationName =>
      _activeWidgetConfiguration?.name ?? 'n/a';

  String get deviceVersion => "0.1";

  /*
  * Networking
  */
  String? _matrixIp;

  void _resetConnectionStatus() {
    _isCoapConnected = null;
    if (_isBleConnected == false) {
      _isBleConnected= null;
    }
    _isConnecting = null;
    _matrixIp = null;
    notifyListeners();
  }

  /// Get the matrix IP
  String get matrixIp => _matrixIp ?? 'n/a';

  Future connect({String? ip = null}) async {
    if (_isCoapConnected != null) return;
    logger.i('Checking connection status');

    // Ping matrix again in x seconds
    // TODO: view gh issue to improve this in future
    // Timer.periodic(Duration(seconds: 10), (timer) async {
    //   _resetConnectionStatus();
    //   timer.cancel();
    //   connect();
    // });

    // Reset
    _isCoapConnected = false;
    _isConnecting = true;
    notifyListeners();

    // Try to get matrix IP
    var matrixIp = ip ?? await _autoGetMatrixIp();

    if (matrixIp != null && await _pingMatrix(matrixIp)) {

      // We are connected now!
      _matrixIp = matrixIp;
      CoapService.setMatrixIp(matrixIp);
      _isCoapConnected = true;

      try {
        var result = await widgetsRepository.getActiveWidget();
        _activeWidget = result.$1;
        _activeWidgetConfiguration = result.$2;
      } catch (e) {
        logger.e('Error getting active widget');
      }
    }
    _isConnecting = false;
    notifyListeners();

    // Connect to the matrix BLE if we are not connected
    if(!_bleDeviceConnected()) {
      await _searchAndConnectBleDevice();
    }
    if (_bleDeviceConnected()) {
      _isBleConnected = true;
    } else {
      _isBleConnected = false;
    }

    notifyListeners();
  }

  Future<void> retryConnection() async
  {
    _resetConnectionStatus();
    await connect();
  }

  /// Tries to get the matrix IP from the preferences, with BLE characteristics or the debug IP
  Future<String?> _autoGetMatrixIp() async {

    // Preferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Try to get the matrix IP from the preferences
    var lastKnownMatrixIp = prefs.getString('matrixIp');
    if (lastKnownMatrixIp != null && await _pingMatrix(lastKnownMatrixIp))
      return lastKnownMatrixIp;

    // IP from settings did not work, try with BLE
    if (!_bleDeviceConnected()) {
      await _searchAndConnectBleDevice();
    }
    try {
      ensureBleDeviceConnected();
      var ipFromBle = await _matrixBleService.getMatrixIp(_connectedMatrix!);
      if (ipFromBle != null && await _pingMatrix(ipFromBle)) {
        prefs.setString('matrixIp', ipFromBle);
        return ipFromBle;
      }
    } catch (e) {
      logger.e('BLE connection failed');
    }

    // As final resort, use the debug IP
    if (await _pingMatrix(Configs.debugMatrixIp)) {
      prefs.setString('matrixIp', Configs.debugMatrixIp);
      return Configs.debugMatrixIp;
    }

    return null;
  }

  /// Pings the matrix to check if it's reachable
  Future<bool> _pingMatrix(String ip) async {
    try {
    var client = CoapClient(
      Uri(
        scheme: 'coap',
        host: ip,
        port: 5683,
      ),
      config: CoapConfig()
    );


      return await client.ping().timeout(Duration(seconds: 5));
    } catch (e) {
      return false;
    }
  }

  /*
  * Matrix control
  */
  Future<void> stopActiveWidget() async {
    if (!hasActiveWidget) {
      Toaster.warning('There is no active widget to stop');
      return;
    }

    await widgetsRepository.unsetActiveWidget();
    _activeWidget = null;
    _activeWidgetConfiguration = null;
    notifyListeners();
  }

  /// Send network credentials to the matrix via BLE and checks if reachability is ok
  Future<void> sendNetworkCredentials(BuildContext context) async
  {
    // Check if BLE is connected
    if (!_bleDeviceConnected()) {
      Toaster.error('BLE is not connected');
      return;
    }

    // Get WiFi SSID
    String wifiName = '';

    // TODO use this to get the wifi name
    // final NetworkInfo _networkInfo = NetworkInfo();
    // if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    //   wifiName = await _networkInfo.getWifiName() ?? '';
    // }

    // Request user to enter wifi SSID
    var userWifiName = await TextInputDialog.show(context, "Enter your WiFi SSID");
    if (userWifiName == null || userWifiName.isEmpty) {
      Toaster.error('You must enter a WiFi SSID');
      return;
    }
    var userWifiPassword = await TextInputDialog.show(context, "Enter your WiFi password");
    if (userWifiPassword == null || userWifiPassword.isEmpty) {
      Toaster.error('You must enter a WiFi password');
      return;
    }

    // Send them to matrix
    await _matrixBleService.sendNetworkCredentials(_connectedMatrix!, userWifiName, userWifiPassword);
  }

  /// Change matrix ip
  Future<void> setManualMatrixIp(BuildContext context) async
  {
    // Request IP from user
    var ip = await TextInputDialog.show(context, "Enter the matrix IP");

    // Check if it's reachable
    Provider.of<MosaicoLoadingState>(context, listen: false).showOverlayLoading();
    if (ip != null && await _pingMatrix(ip)) {
      _matrixIp = ip;
      Toaster.success('Matrix found!');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('matrixIp', ip);
      notifyListeners();
    } else {
      Toaster.error('The matrix is not reachable at given address');
    }
    Provider.of<MosaicoLoadingState>(context, listen: false).hideOverlayLoading();
  }

  /*
  * BLE
  */
  static const String SERVICE_NAME = "PixelForge"; // Friendly name of the matrix
  static BluetoothDevice? _connectedMatrix;
  final MatrixBleService _matrixBleService = MatrixBleService();

  void _onMatrixDisconnected(BluetoothConnectionState state) async {
    if (state == BluetoothConnectionState.disconnected) {
      //Toaster.error("Matrix disconnected");
      logger.d("Matrix disconnected");
      _connectedMatrix = null;
    }
  }

  Future<void> _onMatrixConnected(BluetoothDevice device) async
  {
    //Toaster.success("Connected to matrix");
    logger.d("Matrix found: ${device.advName}");

    // Connect to device and stop scanning
    _connectedMatrix = device;
    FlutterBluePlus.stopScan();
    logger.d("Connected to matrix");


    // listen for disconnection
    var subscription = device.connectionState.listen(_onMatrixDisconnected);
    device.cancelWhenDisconnected(subscription, delayed:true, next:true);
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
    return _connectedMatrix == null ? throw Exception("Matrix is not connected") : _connectedMatrix!;
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
