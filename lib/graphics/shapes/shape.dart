import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphics_3d/graphics/shapes/shape_visitor.dart';

import '../drawing.dart';

abstract class Shape {
  ui.Offset offset;

  Color outlineColor;

  List<Handle> get handles => [];

  Shape(this.offset, {this.outlineColor = Colors.black});

  void draw(Uint8List pixels, ui.Size size, {bool antiAlias = false});

  bool contains(ui.Offset offset) => false;

  void move(ui.Offset offset) {
    this.offset += offset;
  }

  void drawHandles(Uint8List pixels, ui.Size size) {
    for (var handle in handles) {
      handle.draw(pixels, size);
    }
  }

  void accept(ShapeVisitor visitor);
}
