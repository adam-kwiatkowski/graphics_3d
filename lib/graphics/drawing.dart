import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphics_3d/graphics/shapes/triangle.dart';

import 'shapes/line.dart';

class Drawing {
  Drawing(this.size) {
    pixels = Uint8List(size.width.toInt() * size.height.toInt() * 4);
  }

  ui.Size size;
  late final Uint8List pixels;
  bool antialias = true;

  void drawLine(Line line) {
    line.draw(pixels, size, antiAlias: antialias);
  }

  void drawPixel(ui.Offset offset, Color color) {
    final x = offset.dx.toInt();
    final y = offset.dy.toInt();
    final width = size.width.toInt();
    final height = size.height.toInt();

    if (x >= 0 && x < width && y >= 0 && y < height) {
      final index = (x + y * width) * 4;
      pixels[index] = color.red;
      pixels[index + 1] = color.green;
      pixels[index + 2] = color.blue;
      pixels[index + 3] = color.alpha;
    }
  }

  void drawTriangle(Triangle triangle, {bool? antialias}) {
    var aa = antialias ?? this.antialias;
    triangle.draw(pixels, size, antiAlias: aa);
  }

  void clear({ui.Color? clearColor}) {
    var color = clearColor ?? Colors.white;
    for (var i = 0; i < pixels.length; i += 4) {
      pixels[i] = color.red;
      pixels[i + 1] = color.green;
      pixels[i + 2] = color.blue;
      pixels[i + 3] = color.alpha;
    }
  }

  Future<ui.Image> toImage() {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(pixels, size.width.toInt(), size.height.toInt(),
        ui.PixelFormat.rgba8888, completer.complete);
    return completer.future;
  }
}

class Handle {
  Function(ui.Offset) onMove;
  ui.Offset offset;

  Handle(this.offset, {required this.onMove});

  void draw(Uint8List pixels, ui.Size size) {
    final x = offset.dx.toInt();
    final y = offset.dy.toInt();

    for (var i = -5; i <= 5; i++) {
      for (var j = -5; j <= 5; j++) {
        if (x + i >= 0 &&
            x + i < size.width.toInt() &&
            y + j >= 0 &&
            y + j < size.height.toInt()) {
          final index = (x + i + (y + j) * size.width.toInt()) * 4;
          pixels[index] = 0;
          pixels[index + 1] = 0;
          pixels[index + 2] = 0;
          pixels[index + 3] = 255;
        }
      }
    }
    for (var i = -4; i < 5; i++) {
      for (var j = -4; j < 5; j++) {
        if (x + i >= 0 &&
            x + i < size.width.toInt() &&
            y + j >= 0 &&
            y + j < size.height.toInt()) {
          final index = (x + i + (y + j) * size.width.toInt()) * 4;
          pixels[index] = 255;
          pixels[index + 1] = 255;
          pixels[index + 2] = 255;
          pixels[index + 3] = 255;
        }
      }
    }
  }

  bool contains(ui.Offset offset) {
    return (this.offset - offset).distance < 8;
  }
}

class Brush {
  final List<ui.Offset> points;
  final Color color;

  Brush(this.points, {this.color = Colors.black});

  void draw(Uint8List pixels, ui.Size size, ui.Offset offset) {
    for (var point in points) {
      final x = (point.dx + offset.dx).toInt();
      final y = (point.dy + offset.dy).toInt();
      final width = size.width.toInt();
      final height = size.height.toInt();

      if (x >= 0 && x < width && y >= 0 && y < height) {
        final index = (x + y * width) * 4;
        pixels[index] = color.red;
        pixels[index + 1] = color.green;
        pixels[index + 2] = color.blue;
        pixels[index + 3] = color.alpha;
      }
    }
  }

  static Brush rounded(int radius, {Color color = Colors.black}) {
    final points = <ui.Offset>[];
    for (var i = -radius; i < radius; i++) {
      for (var j = -radius; j < radius; j++) {
        if (i * i + j * j >= radius * radius) continue;
        points.add(ui.Offset(i.toDouble(), j.toDouble()));
      }
    }
    return Brush(points, color: color);
  }
}
