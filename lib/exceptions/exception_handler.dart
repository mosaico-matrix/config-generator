import 'package:mosaico_flutter_core/toaster.dart';
import 'coap_exception.dart';

void handleException(Object error, StackTrace stackTrace)
{
  switch (error.runtimeType) {
    case CoapException:
      Toaster.error(error.toString());
      break;
  }
}