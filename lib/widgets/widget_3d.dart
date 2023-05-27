import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:graphics_3d/graphics/shapes/mesh_triangle.dart';
import 'package:graphics_3d/graphics_3d/camera.dart';
import 'package:graphics_3d/graphics_3d/cuboid.dart';
import 'package:graphics_3d/graphics_3d/object_3d.dart';
import 'package:graphics_3d/graphics_3d/transform.dart' as t;
import 'package:graphics_3d/math_3d/vector2.dart';
import 'package:graphics_3d/math_3d/vector4.dart';
import 'package:graphics_3d/widgets/objectinfo_panel.dart';
import 'package:graphics_3d/widgets/transformation_panel.dart';

import '../graphics/drawing.dart';
import '../math_3d/vector3.dart';

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
    cameraPosition.position = Vector3(0, 200, -400);
    targetPosition.position = Vector3.zero();

    // _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
    //   setState(() {
    //     widget.objects[2].mesh.rotate(0.1, 0.05, 0.1);
    //   });
    // });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ui.Size size = MediaQuery.of(context).size;
    final Drawing drawing = Drawing(size);
    drawing.clear(clearColor: Colors.white);

    _camera.viewportSize = Vector2(size.width, size.height);
    return Stack(children: [
      FutureBuilder<ui.Image>(
        future: renderDrawing(
            drawing,
            widget.objects +
                [
                  if (drawCameraTarget)
                    Object3D(
                      Cuboid(10, 10, 10, targetPosition.position),
                    ),
                ],
            _camera),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RawImage(
              image: snapshot.data!,
              width: size.width,
              height: size.height,
              fit: BoxFit.fill,
            );
          } else {
            return const SizedBox();
          }
        },
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
                    Text('Fov: $fov'),
                    Slider(
                      value: fov,
                      onChanged: (value) {
                        setState(() {
                          fov = value;
                          (_camera as PerspectiveCamera).fov = fov;
                        });
                      },
                      min: 1,
                      max: 180,
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

Future<ui.Image> renderDrawing(
    Drawing drawing, List<Object3D> objects, Camera camera) {
  MeshTriangle makeTriangle(Vector4 a, Vector4 b, Vector4 c,
      {ui.Color outlineColor = Colors.black, ui.Color? fillColor}) {
    return MeshTriangle(
        Vector3(a.x, a.y, a.z), Vector3(b.x, b.y, b.z), Vector3(c.x, c.y, c.z),
        outlineColor: outlineColor, fillColor: fillColor);
  }

  for (var object in objects) {
    final mesh = object.mesh;
    final projection = camera.project(mesh);
    final projectedPoints = projection.screenPoints;

    for (var triangle in mesh.triangles) {
      var a = projectedPoints[triangle[1]] - projectedPoints[triangle[0]];
      var b = projectedPoints[triangle[2]] - projectedPoints[triangle[0]];

      var cross = Vector3(a.x, a.y, 0).cross(Vector3(b.x, b.y, 0));
      if (cross.z <= 0) {
        continue;
      }

      if (object.texture != null) {
        var p1 = projectedPoints[triangle[0]];
        var p2 = projectedPoints[triangle[1]];
        var p3 = projectedPoints[triangle[2]];
        drawing.drawShape(
          MeshTriangle.withTexture(
              Vector3(p1.x, p1.y, p1.z),
              Vector3(p2.x, p2.y, p2.z),
              Vector3(p3.x, p3.y, p3.z),
              object.texture, [
            object.mesh.uv[triangle[0]],
            object.mesh.uv[triangle[1]],
            object.mesh.uv[triangle[2]]
          ]),
        );
      } else {
        drawing.drawShape(makeTriangle(projectedPoints[triangle[0]],
            projectedPoints[triangle[1]], projectedPoints[triangle[2]]));
      }
    }
  }

  return drawing.toImage();
}

class Item {
  String title;
  bool isExpanded;

  Item(this.title, this.isExpanded);
}
