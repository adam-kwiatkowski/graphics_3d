import 'package:graphics_3d/graphics_3d/mesh.dart';
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
      [4, 5, 6],
      [4, 6, 7],
      [8, 9, 10],
      [8, 10, 11],
      [12, 13, 14],
      [12, 14, 15],
      [16, 17, 18],
      [16, 18, 19],
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
  }
}
