import 'dart:math';

import 'package:graphics_3d/graphics_3d/mesh.dart';
import 'package:graphics_3d/math_3d/vector4.dart';

class Cylinder extends Mesh {
  Cylinder(double radius, double height, int sides) {
    vertices = [
      Vector4(0, 0, 0, 1),
      Vector4(0, height, 0, 1),
    ];

    for (int i = 0; i < sides; i++) {
      double angle = i * 2 * pi / sides;
      vertices.add(Vector4(radius * cos(angle), 0, radius * sin(angle), 1));
      vertices
          .add(Vector4(radius * cos(angle), height, radius * sin(angle), 1));
    }

    for (int i = 0; i < sides; i++) {
      triangles.add([0, 2 + 2 * i, 2 + 2 * ((i + 1) % sides)]);
      triangles.add([1, 3 + 2 * i, 3 + 2 * ((i + 1) % sides)]);
      triangles.add([2 + 2 * i, 3 + 2 * i, 3 + 2 * ((i + 1) % sides)]);
      triangles.add(
          [2 + 2 * i, 3 + 2 * ((i + 1) % sides), 2 + 2 * ((i + 1) % sides)]);
    }
  }
}
