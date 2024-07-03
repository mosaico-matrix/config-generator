import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../../../../core/configuration/configs.dart';
import '../../../../core/exceptions/rest_exception.dart';
import '../../../models/serializable.dart';
import '../../../utils/toaster.dart';

class RestService {
  // Logger
  static final logger = Logger(
    printer: PrettyPrinter(),
  );

  static const String baseUrl = Configs.apiUrl;
  static const int timeoutSec = 5;

  // Get headers and take the token from the shared preferences
  static Future<Map<String, String>> getHeaders() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String authToken = prefs.getString(Settings.authToken) ?? '';
    // return {
    //   'Authorization': 'Bearer $authToken',
    //   'Content-Type': 'application/json',
    // };
    return {};
  }

  // Function to perform a GET request
  static Future<dynamic> get(String endpoint) async {
    logger.d("GET: $endpoint");
    final response = await http
        .get(
          Uri.parse('$baseUrl/$endpoint'),
          headers: await getHeaders(),
        )
        .timeout(const Duration(seconds: timeoutSec));
    return handleResponse(response);
  }

  static Future<dynamic> put(String endpoint, dynamic data) async {
    logger.d("PUT: $endpoint");
    final response = await http
        .put(
          Uri.parse('$baseUrl/$endpoint'),
          body: jsonEncode(data is Serializable ? data.toJson() : data),
          headers: await getHeaders(),
        )
        .timeout(const Duration(seconds: timeoutSec));
    return handleResponse(response);
  }

  // Function to perform a POST request
  static Future<dynamic> post(String endpoint, dynamic data) async {
    logger.d("POST: $endpoint");
    final response = await http
        .post(
          Uri.parse('$baseUrl/$endpoint'),
          body: jsonEncode(data is Serializable ? data.toJson() : data),
          headers: await getHeaders(),
        )
        .timeout(const Duration(seconds: timeoutSec));
    return handleResponse(response);
  }

  // Function to perform a DELETE request
  static Future<dynamic> delete(String endpoint) async {
    logger.d("DELETE: $endpoint");
    final response = await http
        .delete(
          Uri.parse('$baseUrl/$endpoint'),
          headers: await getHeaders(),
        )
        .timeout(const Duration(seconds: timeoutSec));
    return handleResponse(response);
  }

  static Future<dynamic> handleResponse(http.Response response) async {
    // Internal server error
    if (response.statusCode == 500) {
      logger.e("Request: ${response.request?.url} failed. \n ${response.body}");
      throw RestException(
          "Internal server error, please try again later", response.statusCode);
    }

    // Decode the response
    var data = json.decode(response.body);
    String? message = data['message'];

    // Some type of error
    if (response.statusCode != 200 && response.statusCode != 201) {
      if (message != null && message.isNotEmpty) {
        Toaster.error(message);
      }
      throw RestException(message ?? "An error occurred", response.statusCode);
    }

    // Success
    if (message != null && message.isNotEmpty) Toaster.success(message);
    return data['data'];
  }
}
