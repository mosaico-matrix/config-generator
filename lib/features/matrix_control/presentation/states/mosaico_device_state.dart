import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mosaico_flutter_core/core/configuration/configs.dart';
import 'package:mosaico_flutter_core/features/matrix_control/domain/usecases/matrix_ble_service.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/data/models/mosaico_widget_configuration.dart';
import 'package:mosaico_flutter_core/features/mosaico_widgets/data/repositories/mosaico_widgets_coap_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/networking/services/ble/ble_connection_manager.dart';
import '../../../../core/utils/toaster.dart';
import '../../../mosaico_widgets/data/models/mosaico_widget.dart';
import '../../../mosaico_widgets/domain/repositories/mosaico_local_widgets_repository.dart';

class MosaicoDeviceState with ChangeNotifier {

  /// Logger
  final logger = Logger(printer: PrettyPrinter());

  /// Repository
  MosaicoLocalWidgetsRepository widgetsRepository = MosaicoWidgetsCoapRepository();

  /// Connection status
  bool? _isBleConnected; // At first we don't know if BLE is connected
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
      isConnected ? 'Connected' : 'Disconnected';

  /// BLE connection status
  String get bleConnectionStatusText =>
      _isBleConnected == true ? 'BLE available' : 'BLE not available';

  /// Device info
  MosaicoWidget? _activeWidget;
  bool get hasActiveWidget => _activeWidget != null;
  String get activeWidgetName => _activeWidget?.name ?? 'n/a';
  MosaicoWidgetConfiguration? _activeWidgetConfiguration;
  String get activeWidgetConfigurationName =>
      _activeWidgetConfiguration?.name ?? 'n/a';
  String? _matrixIp;


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

  Future connect() async {
    if (_isCoapConnected != null) return;
    logger.i('Checking connection status');

    // Ping matrix again in x seconds
    // TODO: view gh issue to improve this in future
    Timer.periodic(Duration(seconds: 30), (timer) async {
      _resetConnectionStatus();
      timer.cancel();
      connect();
    });


    _isCoapConnected = false;
    _isBleConnected = false;
    _isConnecting = true;

    // Start BLE connection
    await BLEConnectionManager.searchAndConnectMatrix();
    _isBleConnected = BLEConnectionManager.matrixConnected();

    // Try to connect to the matrix
    var matrixIp = await _getMatrixIp();

    try {
      var result = await widgetsRepository.getActiveWidget();
      _activeWidget = result.$1;
      _activeWidgetConfiguration = result.$2;
    } catch (e) {
      _isCoapConnected = false;
      _isConnecting = false;
      notifyListeners();
      rethrow;
    }

    _isConnecting = false;
    _isCoapConnected = true;
    notifyListeners();
  }

  Future<String> _getMatrixIp() async {

    // Preferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Try to get the matrix IP from the preferences
    _matrixIp = prefs.getString('matrixIp');
    if (_matrixIp != null && await _pingMatrix(_matrixIp!)) return _matrixIp!;

    // IP from settings did not work, try with BLE
    if (_isBleConnected == true) {
      try {
        _matrixIp = await MatrixBle.getMatrixIp();
        Toaster.info('Matrix IP from BLE: $_matrixIp');
        if (await _pingMatrix(_matrixIp!)) {
          await prefs.setString('matrixIp', _matrixIp!);
          return _matrixIp!;
        }
        return _matrixIp!;
      } catch (e) {
        Toaster.error('Could not get matrix IP from BLE');
      }
    }

    return Configs.debugMatrixIp;
  }

  Future<bool> _pingMatrix(String matrixIp) async {
    return false;
  }

  void _resetConnectionStatus() {
    _isCoapConnected = null;
    _isBleConnected = null;
  }
}
