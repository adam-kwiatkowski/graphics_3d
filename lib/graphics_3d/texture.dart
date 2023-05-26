import 'dart:typed_data';
import 'dart:ui';

import 'package:cross_file/cross_file.dart';

class Texture {
  Uint8List data;
  int width;
  int height;

  Texture(this.data, this.width, this.height);

  Color getPixel(int x, int y) {
    int index = (y * width + x) * 4;
    return Color.fromARGB(
        data[index + 3], data[index], data[index + 1], data[index + 2]);
  }

  void load(XFile file) async {
    var bytes = await file.readAsBytes();
    decodeImageFromList(bytes, (result) {
      result.toByteData().then((value) => data = value!.buffer.asUint8List());
      width = result.width;
      height = result.height;
    });
  }

  @override
  String toString() {
    return 'Texture($width x $height)';
  }
}
