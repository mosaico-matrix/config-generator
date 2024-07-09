import 'dart:async';
import 'dart:convert';
import 'package:coap/coap.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../../configuration/coap_config.dart';
import '../../../configuration/configs.dart';
import '../../../exceptions/coap_exception.dart';
import '../../../utils/toaster.dart';

// Base CoAP client class
class CoapService {

  // Logger
  static final logger = Logger(
    printer: PrettyPrinter(),
  );

  static CoapClient _client = _initClient(Configs.debugMatrixIp);

  /// Re-creates the client with the new IP
  static void setMatrixIp(String ip) {
    _client = _initClient(ip);
  }

  static CoapClient _initClient(String ip)
  {
    return _client = CoapClient(
      Uri(
        scheme: 'coap',
        host: ip,
        port: 5683,
      ),
      config: CoapConfig(),
    );
  }

  static Future<dynamic> _processResponse(CoapResponse response) async {
    // Decode from json
    final decodedResponse = json.decode(response.payloadString);
    //logger.d(decodedResponse);

    // Check if need to display a message
    final message = decodedResponse['message'];
    if (message != null && message.isNotEmpty) {
      response.isSuccess ? Toaster.success(message) : throw CoapException(message: message);
    }

    // Return final data
    return decodedResponse['data'];
  }

  static Future<dynamic> get(String path) async {

    logger.d("GET: $path");

    try {
      final response = await _client.get(Uri(path: path));
      return _processResponse(response);
    } catch (e) {
      throw CoapException();
    }
  }

  static Future<dynamic> delete(String path) async {
    logger.d("DELETE: $path");

    try {
      final response = await _client.delete(Uri(path: path));
      return _processResponse(response);
    } catch (e) {
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
      throw CoapException();
    }
  }

  // DONT KNOW WHY THIS MAKES A POST REQUEST
  // static Future<dynamic> put(String path, String payload,
  //     [List<Option<Object>>? options]) async {
  //   logger.d("PUT: $path");
  //
  //   try {
  //     final response = await _client.put(Uri(path: path),
  //         payload: payload, options: options);
  //     return _processResponse(response);
  //   } catch (e) {
  //     throw CoapException();
  //   }
  // }

}
