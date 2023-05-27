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
      [4, 0, 3],
      [4, 3, 7],
      [5, 4, 7],
      [5, 7, 6],
      [1, 5, 6],
      [1, 6, 2],
      [4, 5, 1],
      [4, 1, 0],
      [3, 2, 6],
      [3, 6, 7],
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

    // texture is in the form of a 3x2 grid
    uv = [
      // front
      Vector2(0, 1 / 2),
      Vector2(1 / 3, 1 / 2),
      Vector2(1 / 3, 1),
      Vector2(1 / 3, 1),

      // back
      Vector2(1 / 3, 1 / 2),
      Vector2(2 / 3, 1 / 2),
      Vector2(2 / 3, 1),
      Vector2(2 / 3, 1),

      // top
      Vector2(1 / 3, 0),
      Vector2(2 / 3, 0),
      Vector2(2 / 3, 1 / 2),
      Vector2(2 / 3, 1 / 2),

      // bottom
      Vector2(1 / 3, 1 / 2),
      Vector2(2 / 3, 1 / 2),
      Vector2(2 / 3, 1),
      Vector2(2 / 3, 1),

      // left
      Vector2(2 / 3, 1 / 2),
      Vector2(1, 1 / 2),
      Vector2(1, 1),
      Vector2(1, 1),
    ];
  }
}
