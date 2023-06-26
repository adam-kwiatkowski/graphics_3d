import 'dart:math';

import 'package:graphics_3d/graphics_3d/mesh.dart';
import 'package:graphics_3d/math_3d/vector2.dart';
import 'package:graphics_3d/math_3d/vector3.dart';
import 'package:graphics_3d/math_3d/vector4.dart';

class Cylinder extends Mesh {
  Cylinder(double radius, double height, int sides, Vector3 position) {
    vertices = List<Vector4>.filled(4 * sides + 2, Vector4(0, 0, 0, 0));
    normals = List<Vector4>.filled(4 * sides + 2, Vector4(0, 0, 0, 0));
    triangles = List<List<int>>.filled(4 * sides, List<int>.filled(3, 0));
    uv = List<Vector2>.filled(4 * sides + 2, Vector2(0, 0));

    // Top base
    vertices[0] = Vector4(0, height, 0, 1);
    normals[0] = Vector4(0, 1, 0, 0);
    for (int i = 0; i < sides; i++) {
      vertices[i + 1] = Vector4(radius * cos(2 * pi * i / sides), height, radius * sin(2 * pi * i / sides), 1);
      normals[i + 1] = Vector4(0, 1, 0, 0);
    }

    // Bottom base
    vertices[4 * sides + 1] = Vector4(0, 0, 0, 1);
    normals[4 * sides + 1] = Vector4(0, -1, 0, 0);
    for (int i = 0; i < sides; i++) {
      vertices[3 * sides + i + 1] = Vector4(radius * cos(2 * pi * i / sides), 0, radius * sin(2 * pi * i / sides), 1);
      normals[3 * sides + i + 1] = Vector4(0, -1, 0, 0);
    }

    // Side
    for (int i = 0; i < sides; i++) {
      vertices[sides + i + 1] = Vector4(radius * cos(2 * pi * i / sides), height, radius * sin(2 * pi * i / sides), 1);
      normals[sides + i + 1] = Vector4(radius * cos(2 * pi * i / sides) / radius, 0, radius * sin(2 * pi * i / sides) / radius, 0);
      vertices[2 * sides + i + 1] = Vector4(radius * cos(2 * pi * i / sides), 0, radius * sin(2 * pi * i / sides), 1);
      normals[2 * sides + i + 1] = Vector4(radius * cos(2 * pi * i / sides) / radius, 0, radius * sin(2 * pi * i / sides) / radius, 0);
    }

    // Top base triangles
    for (int i = 0; i < sides - 1; i++) {
      triangles[i] = [0, i + 2, i + 1];
    }
    triangles[sides - 1] = [0, 1, sides];

    // Bottom base triangles
    for (int i = 0; i < sides - 1; i++) {
      triangles[sides + i] = [4 * sides + 1, 3 * sides + i + 1, 3 * sides + i + 2];
    }
    triangles[2 * sides - 1] = [4 * sides + 1, 4 * sides, 3 * sides + 1];

    // Side triangles
    for (int i = 0; i < sides - 1; i++) {
      triangles[2 * sides + i] = [sides + i + 1, sides + i + 2, 2 * sides + i + 1];
      triangles[3 * sides + i] = [2 * sides + i + 2, 2 * sides + i + 1, sides + i + 2];
    }

    triangles[3 * sides - 1] = [2 * sides, sides + 1, 3 * sides];
    triangles[4 * sides - 1] = [3 * sides, sides + 1, 2 * sides + 1];

    uv[0] = Vector2(0.25, 0.25);
    for (int i = 0; i < sides; i++) {
      uv[i + 1] = Vector2(0.25 * (1 + cos(2 * pi * i / sides)), 0.25 * (1 + sin(2 * pi * i / sides)));
    }

    uv[4 * sides + 1] = Vector2(0.75, 0.25);
    for (int i = 0; i < sides; i++) {
      uv[3 * sides + i + 1] = Vector2(0.25 * (3 + cos(2 * pi * i / sides)), 0.25 * (1 + sin(2 * pi * i / sides)));
    }

    for (int i = 0; i < sides; i++) {
      uv[sides + i + 1] = Vector2(i / (sides - 1), 1);
      uv[2 * sides + i + 1] = Vector2(i / (sides - 1), 0.5);
    }

    transform.position = position;
  }
}
