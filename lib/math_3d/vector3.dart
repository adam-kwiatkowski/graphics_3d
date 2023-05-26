import 'dart:math';

import 'matrix.dart';

class Vector3 {
  double x;
  double y;
  double z;

  Vector3(this.x, this.y, this.z);

  Vector3 operator +(Vector3 other) {
    return Vector3(x + other.x, y + other.y, z + other.z);
  }

  Vector3 operator -(Vector3 other) {
    return Vector3(x - other.x, y - other.y, z - other.z);
  }

  Vector3 operator *(double scalar) {
    return Vector3(x * scalar, y * scalar, z * scalar);
  }

  Vector3 operator /(double scalar) {
    return Vector3(x / scalar, y / scalar, z / scalar);
  }

  double dot(Vector3 other) {
    return x * other.x + y * other.y + z * other.z;
  }

  Vector3 cross(Vector3 other) {
    return Vector3(y * other.z - z * other.y, z * other.x - x * other.z,
        x * other.y - y * other.x);
  }

  Matrix toMatrix() {
    return Matrix([
      [x],
      [y],
      [z]
    ]);
  }

  double get magnitude => sqrt(x * x + y * y + z * z);

  Vector3 get normalized => this / magnitude;

  @override
  String toString() {
    return 'Vector3{x: $x, y: $y, z: $z}';
  }

  Vector3.zero() : this(0, 0, 0);
}
