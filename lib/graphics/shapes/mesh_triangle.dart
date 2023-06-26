import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:graphics_3d/graphics/shapes/line.dart';
import 'package:graphics_3d/graphics/shapes/shape.dart';
import 'package:graphics_3d/graphics/shapes/shape_visitor.dart';
import 'package:graphics_3d/graphics_3d/texture.dart';
import 'package:graphics_3d/math_3d/vector2.dart';
import 'package:graphics_3d/math_3d/vector3.dart';

Offset vec3ToOffset(Vector3 vec3) => Offset(vec3.x, vec3.y);

Vector3 toBarycentric(Vector3 p, Vector3 a, Vector3 b, Vector3 c) {
  final v0 = b - a;
  final v1 = c - a;
  final v2 = p - a;
  final d00 = v0.dot(v0);
  final d01 = v0.dot(v1);
  final d11 = v1.dot(v1);
  final d20 = v2.dot(v0);
  final d21 = v2.dot(v1);
  final denom = d00 * d11 - d01 * d01;
  final v = (d11 * d20 - d01 * d21) / denom;
  final w = (d00 * d21 - d01 * d20) / denom;
  final u = 1.0 - v - w;
  return Vector3(u, v, w);
}

class MeshTriangle extends Shape {
  Vector3 point1;
  Vector3 point2;
  Vector3 point3;
  Color? fillColor;
  Texture? texture;
  List<Vector2>? uvs;

  MeshTriangle(this.point1, this.point2, this.point3,
      {this.fillColor, super.outlineColor})
      : super(vec3ToOffset(point1));

  MeshTriangle.withTexture(
      this.point1, this.point2, this.point3, this.texture, this.uvs,
      {super.outlineColor})
      : super(vec3ToOffset(point1));

  @override
  void accept(ShapeVisitor visitor) {}

  @override
  void draw(Uint8List pixels, Size size, {bool antiAlias = false}) {
    if (outlineColor != const Color(0x00000000)) {
      Line(vec3ToOffset(point1), vec3ToOffset(point2),
              outlineColor: outlineColor)
          .draw(pixels, size, antiAlias: antiAlias);
      Line(vec3ToOffset(point2), vec3ToOffset(point3),
              outlineColor: outlineColor)
          .draw(pixels, size, antiAlias: antiAlias);
      Line(vec3ToOffset(point3), vec3ToOffset(point1),
              outlineColor: outlineColor)
          .draw(pixels, size, antiAlias: antiAlias);
    }
    if (fillColor != null) {
      fillTriangle(point1, point2, point3, pixels, size, (x, y) => fillColor!);
    } else if (texture != null && uvs != null) {
      fillTriangle(point1, point2, point3, pixels, size, (x, y) {
        return const Color(0xffff0000);
      });
    }
  }

  void setPixel(int x, int y, Uint8List pixels, Size size, Color color) {
    if (x < 0 || x >= size.width || y < 0 || y >= size.height) {
      return;
    }
    final index = (y * size.width.round() + x) * 4;
    pixels[index] = color.red;
    pixels[index + 1] = color.green;
    pixels[index + 2] = color.blue;
    pixels[index + 3] = color.alpha;
  }

  void fillTriangle(Vector3 point1, Vector3 point2, Vector3 point3,
      Uint8List pixels, Size size, Color Function(dynamic x, dynamic y) color) {
    final minX = min(point1.x, min(point2.x, point3.x));
    final maxX = max(point1.x, max(point2.x, point3.x));
    final minY = min(point1.y, min(point2.y, point3.y));
    final maxY = max(point1.y, max(point2.y, point3.y));

    for (var x = minX; x <= maxX; x++) {
      for (var y = minY; y <= maxY; y++) {
        final barycentric =
            toBarycentric(Vector3(x, y, 0), point1, point2, point3);
        if (barycentric.x < 0 || barycentric.y < 0 || barycentric.z < 0) {
          continue;
        }

        final uvx = barycentric.x * uvs![0].x +
            barycentric.y * uvs![1].x +
            barycentric.z * uvs![2].x;
        final uvy = barycentric.x * uvs![0].y +
            barycentric.y * uvs![1].y +
            barycentric.z * uvs![2].y;

        setPixel(x.round(), y.round(), pixels, size, texture!.getUV(uvx, uvy));

        //   for debug paint hue corresponding to uv
        // setPixel(x.round(), y.round(), pixels, size,
        //     Color.fromARGB(255, (uvx * 255).round(), (uvy * 255).round(), 0));
      }
    }
  }
}
