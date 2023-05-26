import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphics_3d/graphics_3d/camera.dart';
import 'package:graphics_3d/graphics_3d/mesh.dart';

class RotatingCube extends StatefulWidget {
  final Mesh cube;

  const RotatingCube({Key? key, required this.cube}) : super(key: key);

  @override
  State<RotatingCube> createState() => _RotatingCubeState();
}

class _RotatingCubeState extends State<RotatingCube> {
  late Timer _timer;
  final double _angle = 0.01;
  final Camera _camera = PerspectiveCamera(1000, 400, 300);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        widget.cube.rotate(0, _angle, 0);
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
    return Stack(children: [
      CustomPaint(
        painter: CubePainter(_camera, [widget.cube]),
      ),
      Positioned(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('cx: ${(_camera as PerspectiveCamera).cx}'),
          Slider(
              value: (_camera as PerspectiveCamera).cx,
              min: 0,
              max: 800,
              onChanged: (value) {
                setState(() {
                  (_camera as PerspectiveCamera).cx = value;
                });
              }),
          Text('cy: ${(_camera as PerspectiveCamera).cy}'),
          Slider(
              value: (_camera as PerspectiveCamera).cy,
              min: 0,
              max: 800,
              onChanged: (value) {
                setState(() {
                  (_camera as PerspectiveCamera).cy = value;
                });
              }),
          Text('d: ${(_camera as PerspectiveCamera).d}'),
          Slider(
              value: (_camera as PerspectiveCamera).d,
              min: 0,
              max: 1000,
              onChanged: (value) {
                setState(() {
                  (_camera as PerspectiveCamera).d = value;
                });
              }),
        ],
      )),
    ]);
  }
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
