import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphics_3d/graphics_3d/camera.dart';
import 'package:graphics_3d/graphics_3d/cuboid.dart';
import 'package:graphics_3d/graphics_3d/object_3d.dart';
import 'package:graphics_3d/graphics_3d/transform.dart' as t;
import 'package:graphics_3d/math_3d/vector2.dart';
import 'package:graphics_3d/widgets/objectinfo_panel.dart';
import 'package:graphics_3d/widgets/transformation_panel.dart';

import 'math_3d/vector3.dart';

class Renderer3D extends StatefulWidget {
  final List<Object3D> objects;

  const Renderer3D({Key? key, required this.objects}) : super(key: key);

  @override
  State<Renderer3D> createState() => _Renderer3DState();
}

class _Renderer3DState extends State<Renderer3D> {
  late Timer _timer;
  bool drawVertexIndices = false;
  bool drawCameraTarget = false;
  t.Transform cameraPosition = t.Transform();
  t.Transform targetPosition = t.Transform();
  double fov = 90;

  late final Camera _camera = PerspectiveCamera(
      cameraPosition, targetPosition, Vector3.up(), Vector2(800, 600), fov);

  @override
  void initState() {
    super.initState();
    cameraPosition.position = Vector3(0, -200, 400);
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
        painter: CubePainter(
          _camera,
          widget.objects +
              [
                if (drawCameraTarget)
                  Object3D(
                    Cuboid(10, 10, 10, targetPosition.position),
                  ),
              ],
          drawVertexIndices: drawVertexIndices,
        ),
      ),
      Positioned(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 300,
            height: 600,
            child: Card(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var object in widget.objects)
                      Column(
                        children: [
                          ObjectInfoPanel(
                              object: object,
                              onObjectChanged: (object) {
                                setState(() {});
                              }),
                          const SizedBox(height: 20),
                          const Divider()
                        ],
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
                    Slider(
                      value: fov,
                      onChanged: (value) {
                        setState(() {
                          fov = value;
                          (_camera as PerspectiveCamera).fov = fov;
                        });
                      },
                      min: 0,
                      max: 360,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    drawVertexIndices = !drawVertexIndices;
                  });
                },
                child: const Text('Toggle vertex indices'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    drawCameraTarget = !drawCameraTarget;
                  });
                },
                child: const Text('Toggle camera target'),
              ),
            ],
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
  final List<Object3D> _objects;
  final bool drawVertexIndices;

  CubePainter(this._camera, this._objects, {this.drawVertexIndices = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (var object in _objects) {
      final mesh = object.mesh;
      final projection = _camera.project(mesh);
      final projectedPoints = projection.screenPoints;

      for (var triangle in mesh.triangles) {
        var a = projectedPoints[triangle[1]] - projectedPoints[triangle[0]];
        var b = projectedPoints[triangle[2]] - projectedPoints[triangle[0]];

        var cross = Vector3(a.x, a.y, 0).cross(Vector3(b.x, b.y, 0));
        if (cross.z < 0) {
          continue;
        }

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

      if (drawVertexIndices) {
        var visited = List<Vector2>.empty(growable: true);
        for (var i = 0; i < projectedPoints.length; i++) {
          var point = projectedPoints[i];

          for (var j = 0; j < visited.length; j++) {
            if ((visited[j] - point).length() < 10) {
              point = Vector2(point.x, point.y + 10);
            }
          }

          visited.add(point);

          var textPainter = TextPainter(
              text: TextSpan(
                  text: i.toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 10)),
              textDirection: TextDirection.ltr);
          textPainter.layout();
          textPainter.paint(canvas, Offset(point.x, point.y));
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
