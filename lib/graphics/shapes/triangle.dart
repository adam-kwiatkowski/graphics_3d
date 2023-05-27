import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:graphics_3d/graphics/shapes/line.dart';
import 'package:graphics_3d/graphics/shapes/shape.dart';
import 'package:graphics_3d/graphics/shapes/shape_visitor.dart';
import 'package:graphics_3d/graphics_3d/texture.dart';
import 'package:graphics_3d/math_3d/vector2.dart';

class Triangle extends Shape {
  Offset point1;
  Offset point2;
  Offset point3;
  Color? fillColor;
  Texture? texture;
  List<Vector2>? uvs;

  Triangle(this.point1, this.point2, this.point3,
      {this.fillColor, super.outlineColor})
      : super(point1);

  Triangle.withTexture(
      this.point1, this.point2, this.point3, this.texture, this.uvs,
      {super.outlineColor})
      : super(point1);

  @override
  void accept(ShapeVisitor visitor) {}

  @override
  void draw(Uint8List pixels, Size size, {bool antiAlias = false}) {
    if (outlineColor != const Color(0x00000000)) {
      Line(point1, point2, outlineColor: outlineColor)
          .draw(pixels, size, antiAlias: antiAlias);
      Line(point2, point3, outlineColor: outlineColor)
          .draw(pixels, size, antiAlias: antiAlias);
      Line(point3, point1, outlineColor: outlineColor)
          .draw(pixels, size, antiAlias: antiAlias);
    }

    if (fillColor != null) {
      fillTriangle(point1, point2, point3, pixels, size, (x, y) => fillColor!);
    } else if (texture != null && uvs != null) {
      fillTriangle(point1, point2, point3, pixels, size, (x, y) {
        final w1 = ((point2.dy - point3.dy) * (x - point3.dx) +
                (point3.dx - point2.dx) * (y - point3.dy)) /
            ((point2.dy - point3.dy) * (point1.dx - point3.dx) +
                (point3.dx - point2.dx) * (point1.dy - point3.dy));
        final w2 = ((point3.dy - point1.dy) * (x - point3.dx) +
                (point1.dx - point3.dx) * (y - point3.dy)) /
            ((point2.dy - point3.dy) * (point1.dx - point3.dx) +
                (point3.dx - point2.dx) * (point1.dy - point3.dy));
        final w3 = 1 - w1 - w2;

        final uv1 = uvs![0];
        final uv2 = uvs![1];
        final uv3 = uvs![2];

        if (w1 < 0 || w2 < 0 || w3 < 0) {
          return Color(0x00000000);
        }

        final u = uv1.x * w1 + uv2.x * w2 + uv3.x * w3;
        final v = uv1.y * w1 + uv2.y * w2 + uv3.y * w3;

        return Color.fromARGB(255, (u * 255).round(), (v * 255).round(),
            ((1 - (u + v)) * 255).round());
      });
    }
  }

  void fillLine(double x1, double x2, double y, Uint8List pixels, Size size,
      Function(double, double) color) {
    for (var x = min(x1, x2); x <= max(x1, x2); x++) {
      setPixel(x.round(), y.round(), pixels, size, color(x, y));
    }
  }

  void fillBottomFlatTriangle(Offset p1, Offset p2, Offset p3, Uint8List pixels,
      Size size, Function(double, double) color) {
    final invslope1 = (p2.dx - p1.dx) / (p2.dy - p1.dy);
    final invslope2 = (p3.dx - p1.dx) / (p3.dy - p1.dy);

    var curx1 = p1.dx;
    var curx2 = p1.dx;

    for (var scanlineY = p1.dy; scanlineY <= p2.dy; scanlineY++) {
      // Line(Offset(curx1, scanlineY), Offset(curx2, scanlineY), outlineColor: fillColor!).draw(pixels, size, antiAlias: false);
      fillLine(curx1, curx2, scanlineY, pixels, size, color);
      curx1 += invslope1;
      curx2 += invslope2;
    }
  }

  void fillTopFlatTriangle(Offset p1, Offset p2, Offset p3, Uint8List pixels,
      Size size, Function(double, double) color) {
    final invslope1 = (p3.dx - p1.dx) / (p3.dy - p1.dy);
    final invslope2 = (p3.dx - p2.dx) / (p3.dy - p2.dy);

    var curx1 = p3.dx;
    var curx2 = p3.dx;

    for (var scanlineY = p3.dy; scanlineY > p1.dy; scanlineY--) {
      // Line(Offset(curx1, scanlineY), Offset(curx2, scanlineY), outlineColor: fillColor!).draw(pixels, size, antiAlias: false);
      fillLine(curx1, curx2, scanlineY, pixels, size, color);
      curx1 -= invslope1;
      curx2 -= invslope2;
    }
  }

  void fillTriangle(Offset point1, Offset point2, Offset point3,
      Uint8List pixels, Size size, Function(double, double) color) {
    if (point1.dy > point2.dy) {
      final temp = point2;
      point2 = point1;
      point1 = temp;
    }
    if (point2.dy > point3.dy) {
      final temp = point2;
      point2 = point3;
      point3 = temp;
    }
    if (point1.dy > point2.dy) {
      final temp = point2;
      point2 = point1;
      point1 = temp;
    }

    if (point2.dy == point3.dy) {
      fillBottomFlatTriangle(point1, point2, point3, pixels, size, color);
    } else if (point1.dy == point2.dy) {
      fillTopFlatTriangle(point1, point2, point3, pixels, size, color);
    } else {
      final point4 = Offset(
          (point1.dx +
                  ((point2.dy - point1.dy) / (point3.dy - point1.dy)) *
                      (point3.dx - point1.dx))
              .roundToDouble(),
          point2.dy);
      fillBottomFlatTriangle(point1, point2, point4, pixels, size, color);
      fillTopFlatTriangle(point2, point4, point3, pixels, size, color);
      fillLine(point2.dx, point4.dx, point2.dy, pixels, size, color);
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
}
