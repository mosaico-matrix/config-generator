import 'dart:async';
import 'dart:convert';
import 'package:coap/coap.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mosaico_flutter_core/configuration/configs.dart';
import 'package:mosaico_flutter_core/toaster.dart';


// Base CoAP client class
class BaseService {

  // Logger
  static final logger = Logger(
    printer: PrettyPrinter(),
  );

  static final _client = CoapClient(
    Uri(
      scheme: 'coap',
      host: Configs.debugMatrixIp,
      port: 5683,
    ),
    config: CoapConfig(),
  );

  static Future<dynamic> _processResponse(CoapResponse response) async {

    // // Throw if not success
    // if (response.statusCodeString == '4.04') {
    //   Toaster.error('COAP response error: ${response.code}');
    // }

    final decodedResponse = json.decode(response.payloadString);
    logger.d(decodedResponse);
    final message = decodedResponse['message'];
    if (message != null && message.isNotEmpty) {
      response.isSuccess ? Toaster.success(message) : Toaster.error(message);
    }
    return decodedResponse['data'];
  }

  static Future<dynamic> get(String path) async {

    logger.d("GET: $path");

    try {
      final response = await _client.get(Uri(path: path));
      return _processResponse(response);
    } catch (e) {
      logger.e(e);
      throw CoapException();
    }
  }

  static Future<dynamic> delete(String path) async {

    logger.d("DELETE: $path");

    try {
      final response = await _client.delete(Uri(path: path));
      return _processResponse(response);
    } catch (e) {
      logger.e(e);
      throw CoapException();
    }
  }

  static Future<dynamic> post(String path, String payload,
      [List<Option<Object>>? options]) async {

    logger.d("POST: $path");

    try {
      final response = await _client.post(Uri(path: path),
          payload: payload, options: options);
      return _processResponse(response);
    } catch (e) {
      logger.e(e);
      throw CoapException();
    }
  }

  static Future<dynamic> put(String path, String payload,
      [List<Option<Object>>? options]) async {

    logger.d("PUT: $path");

    try {
      final response = await _client.put(Uri(path: path),
          payload: payload, options: options);
      return _processResponse(response);
    } catch (e) {
      logger.e(e);
      throw CoapException();
    }
  }


}


class CoapConfig extends DefaultCoapConfig {
  @override
  int get defaultPort => 5683;

  @override
  int get defaultSecurePort => 5684;

  @override
  int get httpPort => 8080;

  @override
  int get ackTimeout => kReleaseMode ? 3000 : 500; // was 3000

  @override
  double get ackRandomFactor => 1.5;

  @override
  double get ackTimeoutScale => 2.0;

  @override
  int get maxRetransmit => kReleaseMode ? 3 : 1; // was 8

  @override
  int get maxMessageSize => 1024;

  @override
  int get preferredBlockSize => 512;

  @override
  int get blockwiseStatusLifetime => 60000;

  @override
  bool get useRandomIDStart => true;

  @override
  int get notificationMaxAge => 128000;

  @override
  int get notificationCheckIntervalTime => 86400000;

  @override
  int get notificationCheckIntervalCount => 100;

  @override
  int get notificationReregistrationBackoff => 2000;

  @override
  int get cropRotationPeriod => 2000;

  @override
  int get exchangeLifetime => 1247000;

  @override
  int get markAndSweepInterval => 10000;

  @override
  int get channelReceivePacketSize => 2048;

  @override
  String get deduplicator => 'MarkAndSweep';
}