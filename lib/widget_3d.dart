import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphics_3d/graphics_3d/camera.dart';
import 'package:graphics_3d/graphics_3d/cuboid.dart';
import 'package:graphics_3d/graphics_3d/cylinder.dart';
import 'package:graphics_3d/graphics_3d/mesh.dart';
import 'package:graphics_3d/graphics_3d/transform.dart' as t;
import 'package:graphics_3d/math_3d/vector2.dart';
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
  t.Transform cameraPosition = t.Transform();
  t.Transform targetPosition = t.Transform();
  double fov = 90;
  late final Camera _camera = PerspectiveCamera(
      cameraPosition, targetPosition, Vector3.up(), Vector2(800, 600), fov);

  @override
  void initState() {
    super.initState();
    cameraPosition.position = Vector3(-20, 0, 200);
    targetPosition.position = Vector3.zero();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _camera.viewportSize = Vector2(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return Stack(children: [
      CustomPaint(
        painter: CubePainter(_camera, [
          widget.cube,
          Cuboid(100, 100, 100, Vector3.zero()),
          Cylinder(50, 150, 10, Vector3(300, -200, 0)),
          Cuboid(10, 10, 10, targetPosition.position),
          Cuboid(10, 10, 10, cameraPosition.position)
        ]),
      ),
      Positioned(
        child: SizedBox(
          width: 300,
          height: 600,
          child: Card(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TransformationPanel(
                    title: 'Cube transform',
                    transform: widget.cube.transform,
                    onTransformChanged: (transform) {
                      setState(() {
                        widget.cube.transform = transform;
                      });
                    },
                  ),
                  TransformationPanel(
                      title: 'Camera position',
                      transform: cameraPosition,
                      onTransformChanged: (transform) {
                        setState(() {
                          cameraPosition = transform;
                        });
                      }),
                  TransformationPanel(
                      title: 'Camera target',
                      transform: targetPosition,
                      onTransformChanged: (transform) {
                        setState(() {
                          targetPosition = transform;
                        });
                      }),
                  Slider(value: fov, onChanged: (value) {
                    setState(() {
                      fov = value;
                      (_camera as PerspectiveCamera).fov = fov;
                    });
                  }, min: 0, max: 360,)
                ],
              ),
            ),
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
