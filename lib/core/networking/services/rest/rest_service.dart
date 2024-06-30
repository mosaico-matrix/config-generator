// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:logger/logger.dart';
// import '../../../../core/configuration/configs.dart';
// import '../../../../core/exceptions/api_exception.dart';
// import '../../models/serializable.dart';
//
//
// class BaseService {
//
//   // Logger
//   static final logger = Logger(
//     printer: PrettyPrinter(),
//   );
//
//   static const String baseUrl = Configs.apiUrl;
//   static const int timeoutSec = 5;
//
//   // Get headers and take the token from the shared preferences
//   static Future<Map<String, String>> getHeaders() async {
//     // SharedPreferences prefs = await SharedPreferences.getInstance();
//     // String authToken = prefs.getString(Settings.authToken) ?? '';
//     // return {
//     //   'Authorization': 'Bearer $authToken',
//     //   'Content-Type': 'application/json',
//     // };
//     return {};
//   }
//
//   // Function to perform a GET request
//   static Future<dynamic> getData(String endpoint) async {
//     logger.d("GET: $endpoint");
//     final response = await http.get(
//       Uri.parse('$baseUrl/$endpoint'),
//       headers: await getHeaders(),
//     ).timeout(const Duration(seconds: timeoutSec));
//     return handleResponse(response);
//   }
//
//   static Future<dynamic> putData(String endpoint, dynamic data) async {
//     logger.d("PUT: $endpoint");
//     final response = await http.put(
//       Uri.parse('$baseUrl/$endpoint'),
//       body: jsonEncode(data is Serializable ? data.toJson() : data),
//       headers: await getHeaders(),
//     ).timeout(const Duration(seconds: timeoutSec));
//     return handleResponse(response);
//   }
//
//   // Function to perform a POST request
//   static Future<dynamic> postData(String endpoint, dynamic data) async {
//     logger.d("POST: $endpoint");
//     final response = await http.post(
//       Uri.parse('$baseUrl/$endpoint'),
//       body: jsonEncode(data is Serializable ? data.toJson() : data),
//       headers: await getHeaders(),
//     ).timeout(const Duration(seconds: timeoutSec));
//     return handleResponse(response);
//   }
//
//   // Function to perform a DELETE request
//   static Future<dynamic> deleteData(String endpoint) async {
//     logger.d("DELETE: $endpoint");
//     final response = await http.delete(
//       Uri.parse('$baseUrl/$endpoint'),
//       headers: await getHeaders(),
//     ).timeout(const Duration(seconds: timeoutSec));
//     return handleResponse(response);
//   }
//
//   static Future<dynamic> handleResponse(http.Response response) async {
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       return json.decode(response.body);
//     } else {
//       logger.e("Request: ${response.request?.url} failed. \n ${response.body}");
//       throw ApiException(json.decode(response.body), response.statusCode);
//     }
//   }
// }
