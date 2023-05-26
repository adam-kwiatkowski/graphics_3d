import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphics_3d/graphics_3d/camera.dart';
import 'package:graphics_3d/graphics_3d/cuboid.dart';
import 'package:graphics_3d/graphics_3d/cylinder.dart';
import 'package:graphics_3d/graphics_3d/mesh.dart';
import 'package:graphics_3d/widgets/transformation_panel.dart';

import 'math_3d/vector3.dart';

class RotatingCube extends StatefulWidget {
  final Mesh cube;

  const RotatingCube({Key? key, required this.cube}) : super(key: key);

  @override
  State<RotatingCube> createState() => _RotatingCubeState();
}

class _RotatingCubeState extends State<RotatingCube> {
  late Timer _timer;
  final Camera _camera = PerspectiveCamera(1000, 400, 300);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CustomPaint(
        painter: CubePainter(_camera, [
          widget.cube,
          Cuboid(100, 100, 100, Vector3.zero()),
          Cylinder(50, 150, 10, Vector3(300, -200, 0))
        ]),
      ),
      Positioned(
        child: SizedBox(
          width: 300,
          height: 600,
          child: TransformationPanel(
            transform: widget.cube.transform,
            onTransformChanged: (transform) {
              setState(() {
                widget.cube.transform = transform;
              });
            },
          ),
        ),
      )
    ]);
  }
}

class Item {
  String title;
  bool isExpanded;

  Item(this.title, this.isExpanded);
}

class CubePainter extends CustomPainter {
  final Camera _camera;
  final List<Mesh> _meshes;

  CubePainter(this._camera, this._meshes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (var mesh in _meshes) {
      final projectedPoints = _camera.project(mesh);
      for (var triangle in mesh.triangles) {
        canvas.drawPath(
            Path()
              ..moveTo(projectedPoints[triangle[0]].x,
                  projectedPoints[triangle[0]].y)
              ..lineTo(projectedPoints[triangle[1]].x,
                  projectedPoints[triangle[1]].y)
              ..lineTo(projectedPoints[triangle[2]].x,
                  projectedPoints[triangle[2]].y)
              ..close(),
            paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
