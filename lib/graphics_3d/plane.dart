import 'package:graphics_3d/graphics_3d/mesh.dart';
import 'package:graphics_3d/math_3d/vector2.dart';
import 'package:graphics_3d/math_3d/vector3.dart';
import 'package:graphics_3d/math_3d/vector4.dart';

class Plane extends Mesh {
  Plane(double width, double height, Vector3 position) {
    vertices = [
      Vector4(0, 0, 0, 1),
      Vector4(width, 0, 0, 1),
      Vector4(width, height, 0, 1),
      Vector4(0, height, 0, 1),
    ];

    triangles = [
      [0, 1, 2],
      [0, 2, 3],
    ];

    normals = [
      Vector4(0, 0, 1, 0),
      Vector4(0, 0, 1, 0),
      Vector4(0, 0, 1, 0),
      Vector4(0, 0, 1, 0),
    ];

    uv = [
      Vector2(0, 0),
      Vector2(1, 0),
      Vector2(1, 1),
      Vector2(0, 1),
    ];

    transform.position = position;
  }
}