import 'dart:math';

import 'matrix.dart';

class Vector4 {
  double x;
  double y;
  double z;
  double w;

  Vector4(this.x, this.y, this.z, this.w);

  Vector4 operator +(Vector4 other) {
    return Vector4(x + other.x, y + other.y, z + other.z, w + other.w);
  }

  Vector4 operator -(Vector4 other) {
    return Vector4(x - other.x, y - other.y, z - other.z, w - other.w);
  }

  Vector4 operator *(double scalar) {
    return Vector4(x * scalar, y * scalar, z * scalar, w * scalar);
  }

  Vector4 operator /(double scalar) {
    return Vector4(x / scalar, y / scalar, z / scalar, w / scalar);
  }

  double dot(Vector4 other) {
    return x * other.x + y * other.y + z * other.z + w * other.w;
  }

  Matrix toMatrix() {
    return Matrix([
      [x],
      [y],
      [z],
      [w]
    ]);
  }

  double get magnitude => sqrt(x * x + y * y + z * z + w * w);

  Vector4 get normalized => this / magnitude;

  @override
  String toString() {
    return 'Vector4{x: $x, y: $y, z: $z, w: $w}';
  }
}
