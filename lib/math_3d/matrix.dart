import 'dart:math';

import 'package:graphics_3d/math_3d/vector2.dart';
import 'package:graphics_3d/math_3d/vector3.dart';
import 'package:graphics_3d/math_3d/vector4.dart';

class Matrix {
  List<List<double>> values;

  Matrix(this.values);

  Matrix dot(Matrix other) {
    if (shape[1] != other.shape[0]) {
      throw Exception(
          'Cannot multiply matrices of different shapes. $shape != ${other.shape}');
    }

    var result = List.generate(
        values.length, (index) => List.filled(other.values[0].length, 0.0));
    for (var i = 0; i < values.length; i++) {
      for (var j = 0; j < other.values[0].length; j++) {
        for (var k = 0; k < values[0].length; k++) {
          result[i][j] += values[i][k] * other.values[k][j];
        }
      }
    }
    return Matrix(result);
  }

  Matrix operator +(Matrix other) {
    if (values.length != other.values.length ||
        values[0].length != other.values[0].length) {
      throw Exception(
          'Matrices must be the same size to add them. $shape != ${other.shape}');
    }

    var result = List.generate(
        values.length, (index) => List.filled(other.values[0].length, 0.0));
    for (var i = 0; i < values.length; i++) {
      for (var j = 0; j < other.values[0].length; j++) {
        result[i][j] = values[i][j] + other.values[i][j];
      }
    }
    return Matrix(result);
  }

  Matrix operator -(Matrix other) {
    if (shape[0] != other.shape[0] || shape[1] != other.shape[1]) {
      throw Exception(
          'Matrices must be the same size to subtract them. $shape != ${other.shape}');
    }

    var result = List.generate(
        values.length, (index) => List.filled(other.values[0].length, 0.0));
    for (var i = 0; i < values.length; i++) {
      for (var j = 0; j < other.values[0].length; j++) {
        result[i][j] = values[i][j] - other.values[i][j];
      }
    }
    return Matrix(result);
  }

  Matrix operator *(double scalar) {
    var result = List.generate(
        values.length, (index) => List.filled(values[0].length, 0.0));
    for (var i = 0; i < values.length; i++) {
      for (var j = 0; j < values[0].length; j++) {
        result[i][j] = values[i][j] * scalar;
      }
    }
    return Matrix(result);
  }

  Matrix operator /(double scalar) {
    var result = List.generate(
        values.length, (index) => List.filled(values[0].length, 0.0));
    for (var i = 0; i < values.length; i++) {
      for (var j = 0; j < values[0].length; j++) {
        result[i][j] = values[i][j] / scalar;
      }
    }
    return Matrix(result);
  }

  List<double> operator [](int index) {
    return values[index];
  }

  List<int> get shape => [values.length, values[0].length];

  Vector2 toVector2() {
    if (shape[0] != 2 || shape[1] != 1) {
      throw Exception(
          'Matrix must be 2x1 to convert to Vector2. $shape != [2, 1]');
    }
    return Vector2(values[0][0], values[1][0]);
  }

  Vector3 toVector3() {
    if (shape[0] != 3 || shape[1] != 1) {
      throw Exception(
          'Matrix must be 3x1 to convert to Vector3. $shape != [3, 1]');
    }
    return Vector3(values[0][0], values[1][0], values[2][0]);
  }

  Vector4 toVector4() {
    if (shape[0] != 4 || shape[1] != 1) {
      throw Exception(
          'Matrix must be 4x1 to convert to Vector4. $shape != [4, 1]');
    }
    return Vector4(values[0][0], values[1][0], values[2][0], values[3][0]);
  }

  @override
  String toString() {
    return 'Matrix{values: $values}';
  }
}

class RotationMatrix extends Matrix {
  RotationMatrix(double angleX, double angleY, double angleZ)
      : super(RotationMatrix.x(angleX)
            .dot(RotationMatrix.y(angleY))
            .dot(RotationMatrix.z(angleZ))
            .values);

  RotationMatrix.x(double angle)
      : super([
          [1, 0, 0, 0],
          [0, cos(angle), -sin(angle), 0],
          [0, sin(angle), cos(angle), 0],
          [0, 0, 0, 1],
        ]);

  RotationMatrix.y(double angle)
      : super([
          [cos(angle), 0, sin(angle), 0],
          [0, 1, 0, 0],
          [-sin(angle), 0, cos(angle), 0],
          [0, 0, 0, 1],
        ]);

  RotationMatrix.z(double angle)
      : super([
          [cos(angle), -sin(angle), 0, 0],
          [sin(angle), cos(angle), 0, 0],
          [0, 0, 1, 0],
          [0, 0, 0, 1],
        ]);
}
