import 'package:graphics_3d/math_3d/matrix.dart';
import 'package:graphics_3d/math_3d/vector3.dart';
import 'package:graphics_3d/math_3d/vector4.dart';

abstract class Mesh {
  List<Vector4> vertices = [];
  List<Vector4> normals = [];
  List<List<int>> triangles = [];
  List<List<int>> uv = [];

  Vector3 position = Vector3(0, 0, 0);

  void rotate(double angleX, double angleY, double angleZ) {
    vertices = vertices
        .map((point) => RotationMatrix(angleX, angleY, angleZ)
            .dot(point.toMatrix())
            .toVector4())
        .toList();
  }
}
