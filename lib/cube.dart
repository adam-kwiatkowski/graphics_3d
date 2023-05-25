import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Matrix {
  List<List<double>> values;

  Matrix(this.values);

  Matrix operator *(Matrix other) {
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

  @override
  String toString() {
    return 'Matrix{values: $values}';
  }

  Matrix.rotationX(double angle)
      : values = [
          [1, 0, 0, 0],
          [0, cos(angle), -sin(angle), 0],
          [0, sin(angle), cos(angle), 0],
          [0, 0, 0, 1],
        ];

  Matrix.rotationY(double angle)
      : values = [
          [cos(angle), 0, sin(angle), 0],
          [0, 1, 0, 0],
          [-sin(angle), 0, cos(angle), 0],
          [0, 0, 0, 1],
        ];

  Matrix.rotationZ(double angle)
      : values = [
          [cos(angle), -sin(angle), 0, 0],
          [sin(angle), cos(angle), 0, 0],
          [0, 0, 1, 0],
          [0, 0, 0, 1],
        ];
}

class AffinePoint {
  double x;
  double y;
  double z;
  double w;

  AffinePoint(this.x, this.y, this.z, this.w);

  @override
  String toString() {
    return '{x: $x, y: $y, z: $z, w: $w}';
  }

  Matrix toMatrix() {
    return Matrix([
      [x],
      [y],
      [z],
      [w],
    ]);
  }

  AffinePoint fromMatrix(Matrix matrix) {
    return AffinePoint(
      matrix.values[0][0],
      matrix.values[1][0],
      matrix.values[2][0],
      matrix.values[3][0],
    );
  }

  AffinePoint operator +(AffinePoint other) {
    return AffinePoint(x + other.x, y + other.y, z + other.z, w + other.w);
  }
}

class PerspectiveProjection {
  double d;
  double cx;
  double cy;

  PerspectiveProjection(this.d, this.cx, this.cy);

  Offset project(AffinePoint point) {
    return Offset(
      cx + d * point.x / (d - point.z),
      cy + d * point.y / (d - point.z),
    );
  }

  List<Offset> projectAll(List<AffinePoint> points) {
    return points.map(project).toList();
  }
}

class Cube {
  late List<AffinePoint> points;

  Cube(this.points);

  @override
  String toString() {
    return 'Cube{points: $points}';
  }

  void rotateX(double angle) {
    var rotationMatrix = Matrix.rotationX(angle);
    points = points
        .map((point) => point.fromMatrix(rotationMatrix * point.toMatrix()))
        .toList();
  }

  void rotateY(double angle) {
    var rotationMatrix = Matrix.rotationY(angle);
    points = points
        .map((point) => point.fromMatrix(rotationMatrix * point.toMatrix()))
        .toList();
  }

  void rotateZ(double angle) {
    var rotationMatrix = Matrix.rotationZ(angle);
    points = points
        .map((point) => point.fromMatrix(rotationMatrix * point.toMatrix()))
        .toList();
  }

  AffinePoint get center {
    var x = points.map((point) => point.x).reduce((a, b) => a + b) / points.length;
    var y = points.map((point) => point.y).reduce((a, b) => a + b) / points.length;
    var z = points.map((point) => point.z).reduce((a, b) => a + b) / points.length;
    return AffinePoint(x, y, z, 1);
  }

  void move(double dx, double dy, double dz) {
    points = points.map((point) => AffinePoint(point.x + dx, point.y + dy, point.z + dz, point.w)).toList();
  }

  Wireframe project(PerspectiveProjection projection) {
    var projectedPoints = projection.projectAll(points);
    return Wireframe([
      [projectedPoints[0], projectedPoints[1]],
      [projectedPoints[1], projectedPoints[2]],
      [projectedPoints[2], projectedPoints[3]],
      [projectedPoints[3], projectedPoints[0]],
      [projectedPoints[4], projectedPoints[5]],
      [projectedPoints[5], projectedPoints[6]],
      [projectedPoints[6], projectedPoints[7]],
      [projectedPoints[7], projectedPoints[4]],
      [projectedPoints[0], projectedPoints[4]],
      [projectedPoints[1], projectedPoints[5]],
      [projectedPoints[2], projectedPoints[6]],
      [projectedPoints[3], projectedPoints[7]],
    ]);
  }

  Cube.centered(double size, AffinePoint center) {
    var halfSize = size / 2;
    points = [
      AffinePoint(-halfSize, -halfSize, -halfSize, 1),
      AffinePoint(halfSize, -halfSize, -halfSize, 1),
      AffinePoint(halfSize, halfSize, -halfSize, 1),
      AffinePoint(-halfSize, halfSize, -halfSize, 1),
      AffinePoint(-halfSize, -halfSize, halfSize, 1),
      AffinePoint(halfSize, -halfSize, halfSize, 1),
      AffinePoint(halfSize, halfSize, halfSize, 1),
      AffinePoint(-halfSize, halfSize, halfSize, 1),
    ];
    points = points.map((point) => point + center).toList();
  }
}

class Wireframe {
  List<List<Offset>> lines;

  Wireframe(this.lines);
}

class RotatingCube extends StatefulWidget {
  final Cube cube;

  const RotatingCube({Key? key, required this.cube}) : super(key: key);

  @override
  State<RotatingCube> createState() => _RotatingCubeState();
}

class _RotatingCubeState extends State<RotatingCube> {
  late Timer _timer;
  final double _angle = 0.01;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        widget.cube.rotateX(_angle);
        // widget.cube.rotateY(_angle);
        // widget.cube.rotateZ(_angle);
        // widget.cube.move(_angle*100, 0, 0);
        // if (widget.cube.center.x > 250) _angle = -0.01;
        // if (widget.cube.center.x < -250) _angle = 0.01;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Wireframe wireframe =
        widget.cube.project(PerspectiveProjection(1000, 400, 300));
    return CustomPaint(
      painter: CubePainter(
        wireframe,
      ),
    );
  }
}

class CubePainter extends CustomPainter {
  final Wireframe _cube;

  CubePainter(this._cube);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (var line in _cube.lines) {
      canvas.drawLine(line[0], line[1], paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
