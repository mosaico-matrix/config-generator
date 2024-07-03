import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:mosaico_flutter_core/core/exceptions/rest_exception.dart';
import 'package:mosaico_flutter_core/core/utils/toaster.dart';
import '../../features/mosaico_loading/presentation/states/mosaico_loading_state.dart';
import 'coap_exception.dart';

// Logger
final logger = Logger(
  printer: PrettyPrinter(),
);

void handleException(
    Object error, StackTrace stackTrace, MosaicoLoadingState loadingState) {
  // Stop loading if it's still running
  loadingState.hideOverlayLoading();
  loadingState.hideLoading();

  // Dispatch error
  switch (error.runtimeType) {
    case CoapException:
      Toaster.error(error.toString());
      break;
    case ClientException:
      Toaster.error('Could not connect to the server, please try again later');
    case RestException:
      Toaster.error(error.toString());
      break;
    default:
      Toaster.error('An error occurred');
      logger.e("Unhandled exception: $error $stackTrace");
  }
}
