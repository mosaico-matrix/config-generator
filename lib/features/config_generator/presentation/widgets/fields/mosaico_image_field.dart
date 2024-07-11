import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:mosaico_flutter_core/common/widgets/mosaico_button.dart';
import 'package:provider/provider.dart';
import '../../states/fields/mosaico_field_state.dart';
import 'mosaico_field.dart';

class MosaicoImageField extends MosaicoField<MosaicoImageFieldState> {
  MosaicoImageField({Key? key}) : super(fieldState: new MosaicoImageFieldState());

  @override
  Widget buildField(BuildContext context) {
    return Consumer<MosaicoImageFieldState>(
      builder: (context, state, _) {
        return Column(
          children: [
            MosaicoButton(
              onPressed: state.pickImage,
              text: 'Pick image',
            ),
            SizedBox(height: 8),
            Builder(builder: (context) {
              if (state.imageBytes != null) {
                return Image.memory(
                  state.imageBytes!,
                  repeat: ImageRepeat.noRepeat,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.none,
                );
              } else {
                return Container();
              }
            }),
          ],
        );
      },
    );
  }
}

class MosaicoImageFieldState extends MosaicoFieldState {

  /// The actual data of the image in PPM format
  String? _ppm;

  /// An image preview in bytes
  Uint8List? _imageBytes;

  Uint8List? get imageBytes => _imageBytes;

  /// Pick image from gallery and convert it to PPM format
  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return; // User cancelled
    }

    // Ask user to crop it in square
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1)
    );
    if (croppedFile == null) {
      return; // User cancelled
    }

    // Get file to bytes
    File file = File(croppedFile.path);
    Uint8List imageBytes = await file.readAsBytes();

    // Decode image
    img.Image? decodedImage = img.decodeImage(imageBytes);
    if (decodedImage == null) {
      return; // Error decoding image
    }

    // Resize image to 64x64
    img.Image resizedImage =
        img.copyResize(decodedImage, width: 64, height: 64);

    // Convert to PPM format
    _ppm = _convertToPPM(resizedImage);
    _imageBytes = Uint8List.fromList(img.encodePng(resizedImage));
    notifyListeners();
  }

  @override
  getAsset() {
    return _ppm;
  }

  @override
  void init(oldValue) async
  {
    if(!isEditMode)
      return;

    // Load image
    var imagePath = getOldConfigPath()! + '/assets/' + getName();
    File file = File(imagePath);
    _ppm = await file.readAsString();
    var image = _convertFromPPM(_ppm!);
    _imageBytes = Uint8List.fromList(img.encodePng(image));
    notifyListeners();
  }


  /*
  * GG to ChatGPT for these ;)
  */
  String _convertToPPM(img.Image image) {
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

  img.Image _convertFromPPM(String ppmString) {
    List<String> lines = ppmString.split('\n');
    int currentLineIndex = 0;

    // Read magic number
    String magicNumber = lines[currentLineIndex++].trim();
    if (magicNumber != 'P3') {
      throw FormatException('Invalid PPM format, only P3 supported');
    }

    // Read width and height
    while (lines[currentLineIndex].startsWith('#')) {
      currentLineIndex++; // skip comments
    }
    List<String> dimensions = lines[currentLineIndex++].trim().split(' ');
    int width = int.parse(dimensions[0]);
    int height = int.parse(dimensions[1]);

    // Read maximum color value
    while (lines[currentLineIndex].startsWith('#')) {
      currentLineIndex++; // skip comments
    }
    int.parse(lines[currentLineIndex++].trim());

    // Create the image
    img.Image image = img.Image(width: width , height: height);

    // Read pixel data
    int x = 0;
    int y = 0;
    for (int i = currentLineIndex; i < lines.length; i++) {
      if (lines[i].startsWith('#') || lines[i].trim().isEmpty) {
        continue; // skip comments and empty lines
      }

      List<String> pixelValues = lines[i].trim().split(RegExp(r'\s+'));
      for (int j = 0; j < pixelValues.length; j += 3) {
        if (x >= width) {
          x = 0;
          y++;
        }
        if (y >= height) {
          break;
        }

        int r = int.parse(pixelValues[j]);
        int g = int.parse(pixelValues[j + 1]);
        int b = int.parse(pixelValues[j + 2]);
        var color = img.ColorRgba8(r, g, b,0);

        image.setPixel(x, y, color);
        x++;
      }
    }

    return image;
  }

  @override
  String? validate() {
    return _ppm != null || !isRequired() ? null : 'You must pick an image';
  }

  @override
  getData() {
    return null;
  }


}
