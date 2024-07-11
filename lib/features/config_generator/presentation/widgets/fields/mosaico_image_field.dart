import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../states/dynamic_form_state.dart';
import '../../states/fields/mosaico_field_state.dart';
import 'mosaico_field.dart';

class MosaicoImageField extends MosaicoField<MosaicoImageFieldState> {
  MosaicoImageField({Key? key}) : super(state: new MosaicoImageFieldState());

  @override
  Widget buildField(BuildContext context) {
    return Consumer<MosaicoImageFieldState>(
      builder: (context, state, _) {
        return ElevatedButton(
          onPressed: () async {
            final ImagePicker picker = ImagePicker();
            final XFile? image = await picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              File file = File(image.path);
              Uint8List imageBytes = await file.readAsBytes();

              // Decode image
              img.Image? decodedImage = img.decodeImage(imageBytes);

              if (decodedImage != null) {
                // Resize image to 64x64
                img.Image resizedImage = img.copyResize(decodedImage, width: 64, height: 64);

                // Convert to PPM format
                String ppmData = convertToPPM(resizedImage);
                state.setPPM(ppmData);
              }
            }
          },
          child: Text("Select image"),
        );
      },
    );
  }

  String convertToPPM(img.Image image) {
    StringBuffer ppm = StringBuffer();
    ppm.writeln('P3');
    ppm.writeln('${image.width} ${image.height}');
    ppm.writeln('255');
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        var pixel = image.getPixel(x, y);
        num r = pixel.r;
        num g = pixel.g;
        num b = pixel.b;
        ppm.write('$r $g $b ');
      }
      ppm.writeln();
    }
    return ppm.toString();
  }
}

class MosaicoImageFieldState extends MosaicoFieldState {

  String? _ppm;
  void setPPM(String ppm) {
    _ppm = ppm;
  }

  @override
  saveDataForEdit() {
    return "";
  }

  @override
  String getConfigScriptLine() {
    return "";
  }

  @override
  getAsset() {
    return _ppm;
  }

  @override
  void init(oldValue) {
    notifyListeners();
  }
}
