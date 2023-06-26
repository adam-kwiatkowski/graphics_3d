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

    uv = [
    //   front face
      Vector2(0, 0),
      Vector2(1, 0),
      Vector2(1, 1),
      Vector2(0, 1),
    //   back face
      Vector2(0, 0),
      Vector2(1, 0),
      Vector2(1, 1),
      Vector2(0, 1),
    //   top face
      Vector2(0, 0),
      Vector2(1, 0),
      Vector2(1, 1),
      Vector2(0, 1),
    //   bottom face
      Vector2(0, 0),
      Vector2(1, 0),
      Vector2(1, 1),
      Vector2(0, 1),
    //   right face
      Vector2(0, 0),
      Vector2(1, 0),
      Vector2(1, 1),
      Vector2(0, 1),
    //   left face
      Vector2(0, 0),
      Vector2(1, 0),
      Vector2(1, 1),
      Vector2(0, 1),
    ];
  }
}
