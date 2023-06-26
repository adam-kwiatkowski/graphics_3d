import 'package:graphics_3d/graphics_3d/mesh.dart';
import 'package:graphics_3d/math_3d/vector2.dart';
import 'package:graphics_3d/math_3d/vector3.dart';
import 'package:graphics_3d/math_3d/vector4.dart';

class Cuboid extends Mesh {
  Cuboid(double width, double height, double depth, Vector3 position) {
    vertices = [
      Vector4(0, 0, depth, 1),
      Vector4(width, 0, depth, 1),
      Vector4(width, height, depth, 1),
      Vector4(0, height, depth, 1),
      Vector4(0, 0, 0, 1),
      Vector4(width, 0, 0, 1),
      Vector4(width, height, 0, 1),
      Vector4(0, height, 0, 1),
      Vector4(0, 0, depth, 1),
      Vector4(width, 0, depth, 1),
      Vector4(width, 0, 0, 1),
      Vector4(0, 0, 0, 1),
      Vector4(0, height, depth, 1),
      Vector4(width, height, depth, 1),
      Vector4(width, height, 0, 1),
      Vector4(0, height, 0, 1),
      Vector4(0, 0, depth, 1),
      Vector4(0, 0, 0, 1),
      Vector4(0, height, 0, 1),
      Vector4(0, height, depth, 1),
      Vector4(width, 0, depth, 1),
      Vector4(width, 0, 0, 1),
      Vector4(width, height, 0, 1),
      Vector4(width, height, depth, 1),
    ];

    triangles = [
      [0, 1, 2],
      [0, 2, 3],
      [4, 6, 5],
      [4, 7, 6],
      [8, 10, 9],
      [8, 11, 10],
      [12, 13, 14],
      [12, 14, 15],
      [16, 18, 17],
      [16, 19, 18],
      [20, 21, 22],
      [20, 22, 23],
    ];

    normals = [
      Vector4(0, 0, 1, 0),
      Vector4(0, 0, 1, 0),
      Vector4(0, 0, 1, 0),
      Vector4(0, 0, 1, 0),
      Vector4(0, 0, -1, 0),
      Vector4(0, 0, -1, 0),
      Vector4(0, 0, -1, 0),
      Vector4(0, 0, -1, 0),
      Vector4(0, 1, 0, 0),
      Vector4(0, 1, 0, 0),
      Vector4(0, 1, 0, 0),
      Vector4(0, 1, 0, 0),
      Vector4(0, -1, 0, 0),
      Vector4(0, -1, 0, 0),
      Vector4(0, -1, 0, 0),
      Vector4(0, -1, 0, 0),
      Vector4(1, 0, 0, 0),
      Vector4(1, 0, 0, 0),
      Vector4(1, 0, 0, 0),
      Vector4(1, 0, 0, 0),
      Vector4(-1, 0, 0, 0),
      Vector4(-1, 0, 0, 0),
      Vector4(-1, 0, 0, 0),
      Vector4(-1, 0, 0, 0),
    ];

    transform.position = position;

    uv = [
      Vector2(0, 0),
      Vector2(1, 0),
      Vector2(1, 1),
      Vector2(0, 1),
      Vector2(1, 0),
      Vector2(0, 0),
      Vector2(0, 1),
      Vector2(1, 1),
      Vector2(0, 1),
      Vector2(1, 1),
      Vector2(1, 0),
      Vector2(0, 0),
      Vector2(1, 1),
      Vector2(0, 1),
      Vector2(0, 0),
      Vector2(1, 0),
      Vector2(1, 0),
      Vector2(0, 0),
      Vector2(0, 1),
      Vector2(1, 1),
      Vector2(0, 0),
      Vector2(1, 0),
      Vector2(1, 1),
      Vector2(0, 1),
    ];
  }
}
