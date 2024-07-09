import 'dart:async';
import 'dart:io';

import 'package:coap/coap.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mosaico_flutter_core/common/widgets/dialogs/text_input_dialog.dart';
import 'package:mosaico_flutter_core/core/configuration/coap_config.dart';
import 'package:mosaico_flutter_core/core/configuration/configs.dart';
import 'package:mosaico_flutter_core/core/exceptions/coap_exception.dart';
import 'package:mosaico_flutter_core/features/matrix_control/domain/usecases/matrix_ble_service.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/data/models/mosaico_widget_configuration.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/data/repositories/mosaico_widgets_coap_repository.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/networking/services/ble/ble_connection_manager.dart';
import '../../../../core/networking/services/coap/coap_service.dart';
import '../../../../core/utils/toaster.dart';
import '../../../mosaico_loading/presentation/states/mosaico_loading_state.dart';
import '../../../mosaico_widgets/data/models/mosaico_widget.dart';
import '../../../mosaico_widgets/domain/repositories/mosaico_local_widgets_repository.dart';

class MosaicoDeviceState with ChangeNotifier {
  /// Logger
  final logger = Logger(printer: PrettyPrinter());

  /// Repository
  MosaicoLocalWidgetsRepository widgetsRepository =
      MosaicoWidgetsCoapRepository();

  /// Connection status
  bool? _isCoapConnected; // At first we don't know if COAP is connected

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
  String get bleConnectionStatusText => BLEConnectionManager.matrixConnected()
      ? 'BLE available'
      : 'BLE not available';

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

  /// Get the matrix IP
  String get matrixIp => _matrixIp ?? 'n/a';

  Future connect({String? ip = null}) async {
    if (_isCoapConnected != null) return;
    logger.i('Checking connection status');

    // Ping matrix again in x seconds
    // TODO: view gh issue to improve this in future
    // Timer.periodic(Duration(seconds: 30), (timer) async {
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
      _isCoapConnected = true;

      try {
        var result = await widgetsRepository.getActiveWidget();
        _activeWidget = result.$1;
        _activeWidgetConfiguration = result.$2;
      } catch (e) {
        // Do not throw here, we need to do other stuff before!
      }
    }
    _isConnecting = false;
    notifyListeners();

    // Connect to the matrix BLE if we are not connected
    if(!BLEConnectionManager.matrixConnected()) {
      await BLEConnectionManager.searchAndConnectMatrix();
    }
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
    if (!BLEConnectionManager.matrixConnected()) {
      await BLEConnectionManager.searchAndConnectMatrix();
    }
    try {
      var ipFromBle = await MatrixBle.getMatrixIp();
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
    //await MatrixBle.

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
}
