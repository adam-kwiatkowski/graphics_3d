import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

Color getBackgroundColor(Uint8List pixels, ui.Size size, int x, int y) {
  final index = (x + y * size.width).toInt() * 4;
  return Color.fromARGB(
    pixels[index + 3],
    pixels[index],
    pixels[index + 1],
    pixels[index + 2],
  );
}

Color blendColors(Color foreground, Color background) {
  final alpha = foreground.alpha / 255;
  final red = (foreground.red * alpha + background.red * (1 - alpha)).round();
  final green =
      (foreground.green * alpha + background.green * (1 - alpha)).round();
  final blue =
      (foreground.blue * alpha + background.blue * (1 - alpha)).round();
  return Color.fromARGB(255, red, green, blue);
}

ui.Color getPixel(Offset offset, Uint8List pixels, Size size) {
  final x = offset.dx.toInt();
  final y = offset.dy.toInt();
  final index = (x + y * size.width.toInt()) * 4;
  return Color.fromARGB(
      pixels[index + 3], pixels[index], pixels[index + 1], pixels[index + 2]);
}

void setPixel(Offset offset, Uint8List pixels, Size size, Color color) {
  final x = offset.dx.toInt();
  final y = offset.dy.toInt();
  final index = (x + y * size.width.toInt()) * 4;
  pixels[index] = color.red;
  pixels[index + 1] = color.green;
  pixels[index + 2] = color.blue;
  pixels[index + 3] = color.alpha;
}

getNeighbors(Offset current, Size size) {
  final neighbors = <Offset>[];
  if (current.dx > 0) {
    neighbors.add(Offset(current.dx - 1, current.dy));
  }
  if (current.dx < size.width - 1) {
    neighbors.add(Offset(current.dx + 1, current.dy));
  }
  if (current.dy > 0) {
    neighbors.add(Offset(current.dx, current.dy - 1));
  }
  if (current.dy < size.height - 1) {
    neighbors.add(Offset(current.dx, current.dy + 1));
  }
  if (current.dx > 0 && current.dy > 0) {
    neighbors.add(Offset(current.dx - 1, current.dy - 1));
  }
  if (current.dx < size.width - 1 && current.dy > 0) {
    neighbors.add(Offset(current.dx + 1, current.dy - 1));
  }
  if (current.dx > 0 && current.dy < size.height - 1) {
    neighbors.add(Offset(current.dx - 1, current.dy + 1));
  }
  if (current.dx < size.width - 1 && current.dy < size.height - 1) {
    neighbors.add(Offset(current.dx + 1, current.dy + 1));
  }
  return neighbors;
}