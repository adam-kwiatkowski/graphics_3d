import 'package:graphics_3d/graphics_3d/mesh.dart';
import 'package:graphics_3d/math_3d/vector2.dart';
import 'package:graphics_3d/math_3d/vector3.dart';
import 'package:graphics_3d/math_3d/vector4.dart';

abstract class Camera {
  Vector3 position = Vector3(0, 0, 0);
  Vector3 target = Vector3(0, 0, 0);
  Vector3 up = Vector3(0, 1, 0);

  List<Vector2> project(Mesh mesh);
}

class PerspectiveCamera extends Camera {
  double d;
  double cx;
  double cy;

  PerspectiveCamera(this.d, this.cx, this.cy);

  Vector2 projectPoint(Vector4 point) {
    return Vector2(
      cx + d * point.x / (d - point.z),
      cy + d * point.y / (d - point.z),
    );
  }

  @override
  List<Vector2> project(Mesh mesh) {
    return mesh.vertices
        .map(mesh.transform.transformPoint)
        .map(projectPoint)
        .toList();
  }
}
