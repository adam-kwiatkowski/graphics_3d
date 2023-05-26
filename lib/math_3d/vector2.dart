import 'dart:math';

import 'matrix.dart';

class Vector2 {
  double x;
  double y;

  Vector2(this.x, this.y);

  Vector2 operator +(Vector2 other) {
    return Vector2(x + other.x, y + other.y);
  }

  Vector2 operator -(Vector2 other) {
    return Vector2(x - other.x, y - other.y);
  }

  Vector2 operator *(double scalar) {
    return Vector2(x * scalar, y * scalar);
  }

  Vector2 operator /(double scalar) {
    return Vector2(x / scalar, y / scalar);
  }

  double dot(Vector2 other) {
    return x * other.x + y * other.y;
  }

  Matrix toMatrix() {
    return Matrix([
      [x],
      [y]
    ]);
  }

  double get magnitude => sqrt(x * x + y * y);

  Vector2 get normalized => this / magnitude;

  @override
  String toString() {
    return 'Vector2{x: $x, y: $y}';
  }

  Vector2 cross(Vector2 other) {
    return Vector2(x * other.y - y * other.x, 0);
  }

  length() {
    return sqrt(x * x + y * y);
  }
}
