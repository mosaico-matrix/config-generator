import 'dart:io' show Platform;

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Configs {
  static String apiUrl = "https://mosaico.murkrowdev.org/api";
  static String debugMatrixIp = Platform.isAndroid ? "10.0.2.2" : "murkrowdev.org";
  static const availableFontSizes = <int>[6,7,8,9,10,12,13,14,15,18,20];
  static Guid mosaicoBLEServiceUUID = Guid("d34fdcd0-83dd-4abe-9c16-1230e89ad2f2");
}