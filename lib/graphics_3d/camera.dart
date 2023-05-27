import 'dart:math';

import 'package:graphics_3d/graphics_3d/mesh.dart';
import 'package:graphics_3d/graphics_3d/transform.dart';
import 'package:graphics_3d/math_3d/matrix.dart';
import 'package:graphics_3d/math_3d/vector2.dart';
import 'package:graphics_3d/math_3d/vector3.dart';
import 'package:graphics_3d/math_3d/vector4.dart';

abstract class Camera {
  Transform transform;
  Transform target;
  Vector3 up;
  Vector2 viewportSize;

  Camera(this.transform, this.target, this.up, this.viewportSize);

  Projection project(Mesh mesh);

  Matrix get viewMatrix {
    Vector3 z = (transform.position - target.position).normalized;
    Vector3 x = up.cross(z).normalized;
    Vector3 y = z.cross(x).normalized;

    return Matrix([
      [x.x, x.y, x.z, x.dot(transform.position)],
      [y.x, y.y, y.z, y.dot(transform.position)],
      [z.x, z.y, z.z, z.dot(transform.position)],
      [0, 0, 0, 1],
    ]);
  }
}

class Projection {
  List<Vector4> worldPoints;
  List<Vector4> normals;
  List<Vector4> screenPoints;

  Projection(this.worldPoints, this.normals, this.screenPoints);
}

class PerspectiveCamera extends Camera {
  double fov;
  double d = 1000;
  double cx = 0;
  double cy = 0;

  PerspectiveCamera(
      super.position, super.target, super.up, super.viewportSize, this.fov) {
    cx = viewportSize.x / 2;
    cy = viewportSize.y / 2;
  }

  Vector4 projectPoint(Vector4 point) {
    return Vector4(
      cx + d * point.x / (d - point.z),
      cy + d * point.y / (d - point.z),
      0,
      0,
    );
  }

  Matrix get projectionMatrix {
    var cot = 1 / tan((fov / 2) * pi / 180);
    return Matrix([
      [-(viewportSize.x / 2) * cot, 0, viewportSize.x / 2, 0],
      [0, (viewportSize.x / 2) * cot, viewportSize.y / 2, 0],
      [0, 0, 0, 1],
      [0, 0, 1, 0],
    ]);
  }

  @override
  Projection project(Mesh mesh) {
    cx = viewportSize.x / 2;
    cy = viewportSize.y / 2;
    var worldPoints = mesh.vertices
        .map((vertex) => mesh.transform.transformPoint(vertex))
        .toList();
    var viewPoints = worldPoints
        .map((point) => viewMatrix.dot(point.toMatrix()).toVector4())
        .toList();
    var projectionPoints = viewPoints
        .map((point) => projectionMatrix.dot(point.toMatrix()).toVector4())
        .toList();
    projectionPoints =
        projectionPoints.map((point) => point / point.w).toList();

    // return viewPoints.map((point) => projectPoint(point)).toList();
    return Projection(worldPoints, mesh.normals, projectionPoints);
  }
}
