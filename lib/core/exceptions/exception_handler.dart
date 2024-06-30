import 'package:logger/logger.dart';
import 'package:mosaico_flutter_core/core/utils/toaster.dart';
import 'coap_exception.dart';

// Logger
final logger = Logger(
  printer: PrettyPrinter(),
);

void handleException(Object error, StackTrace stackTrace)
{
  switch (error.runtimeType) {
    case CoapException:
      Toaster.error(error.toString());
      break;
  }
}