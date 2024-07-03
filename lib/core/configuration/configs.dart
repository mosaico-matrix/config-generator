import 'dart:io' show Platform;

class Configs {
  static String apiUrl = Platform.isAndroid ? "http://10.0.2.2:8000/api" : "http://localhost:8000/api";
  static String debugMatrixIp = Platform.isAndroid ? "10.0.2.2" : "localhost";
  static const availableFontSizes = <int>[6,7,8,9,10,12,13,14,15,18,20];
}