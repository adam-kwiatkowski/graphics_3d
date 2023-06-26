import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:graphics_3d/graphics/shapes/shape_visitor.dart';

import 'shape.dart';

// simple class for drawing digits pixel by pixel

// enum of digits 0-9
enum DigitType { zero, one, two, three, four, five, six, seven, eight, nine }

List<List<List<int>>> digitData = [
  // 0
  [
    [0, 1, 1, 1, 0],
    [1, 0, 0, 0, 1],
    [1, 0, 0, 0, 1],
    [1, 0, 0, 0, 1],
    [0, 1, 1, 1, 0]
  ],
  // 1
  [
    [0, 0, 0, 1, 0],
    [0, 0, 1, 1, 0],
    [0, 1, 0, 1, 0],
    [0, 0, 0, 1, 0],
    [0, 0, 0, 1, 0]
  ],
  // 2
  [
    [0, 1, 1, 1, 0],
    [1, 0, 0, 0, 1],
    [0, 0, 1, 1, 0],
    [0, 1, 0, 0, 0],
    [1, 1, 1, 1, 1]
  ],
  // 3
  [
    [0, 1, 1, 1, 0],
    [1, 0, 0, 0, 1],
    [0, 0, 1, 1, 0],
    [1, 0, 0, 0, 1],
    [0, 1, 1, 1, 0]
  ],
  // 4
  [
    [0, 0, 1, 1, 0],
    [0, 1, 0, 1, 0],
    [1, 1, 1, 1, 0],
    [0, 0, 0, 1, 0],
    [0, 0, 0, 1, 0]
  ],
  // 5
  [
    [1, 1, 1, 1, 1],
    [1, 0, 0, 0, 0],
    [1, 1, 1, 1, 0],
    [0, 0, 0, 0, 1],
    [1, 1, 1, 1, 0]
  ],
  // 6
  [
    [0, 1, 1, 1, 0],
    [1, 0, 0, 0, 0],
    [1, 1, 1, 1, 0],
    [1, 0, 0, 0, 1],
    [0, 1, 1, 1, 0]
  ],
  // 7
  [
    [1, 1, 1, 1, 1],
    [0, 0, 0, 1, 0],
    [0, 0, 1, 0, 0],
    [0, 1, 0, 0, 0],
    [1, 0, 0, 0, 0]
  ],
  // 8
  [
    [0, 1, 1, 1, 0],
    [1, 0, 0, 0, 1],
    [0, 1, 1, 1, 0],
    [1, 0, 0, 0, 1],
    [0, 1, 1, 1, 0]
  ],
  // 9
  [
    [0, 1, 1, 1, 0],
    [1, 0, 0, 0, 1],
    [0, 1, 1, 1, 1],
    [0, 0, 0, 0, 1],
    [0, 1, 1, 1, 0]
  ]
];

List<List<int>> rescaleDigit(List<List<int>> digit, int width, int height) {
  var newDigit = <List<int>>[];

  // naive scaling algorithm
  var dy = 0;
  while (dy < height) {
    var row = <int>[];
    var sy = (dy / height * digit.length).toInt();
    var dx = 0;
    while (dx < width) {
      var sx = (dx / width * digit[0].length).toInt();
      row.add(digit[sy][sx]);
      dx++;
    }
    newDigit.add(row);
    dy++;
  }

  return newDigit;
}

class Digit extends Shape {
  late DigitType digitType;
  ui.Offset start;
  ui.Offset size;

  Digit(int value, this.start,
      {super.outlineColor, this.size = const ui.Offset(5, 5)})
      : super(start) {
    try {
      digitType = DigitType.values[value];
    } catch (e) {
      digitType = DigitType.zero;
    }
  }

  @override
  void accept(ShapeVisitor visitor) {}

  @override
  void draw(Uint8List pixels, ui.Size size, {bool antiAlias = false}) {
    var x = start.dx.toInt();
    var y = start.dy.toInt();
    var digit = digitData[digitType.index];

    if (this.size != const ui.Offset(5, 5)) {
      digit = rescaleDigit(digit, this.size.dx.toInt(), this.size.dy.toInt());
    }

    for (var row = 0; row < digit.length; row++) {
      for (var col = 0; col < digit[row].length; col++) {
        if (digit[row][col] == 1) {
          var index = (x + col + (y + row) * size.width).toInt() * 4;

          if (index < 0 || index >= pixels.length) {
            continue;
          }

          pixels[index] = outlineColor.red;
          pixels[index + 1] = outlineColor.green;
          pixels[index + 2] = outlineColor.blue;
          pixels[index + 3] = outlineColor.alpha;
        }
      }
    }
  }
}

class Number extends Shape {
  late List<Digit> digits;
  late ui.Offset start;
  late int value;
  int spacing;
  ui.Offset digitSize;

  Number(this.value, this.start,
      {super.outlineColor,
      this.digitSize = const ui.Offset(5, 5),
      this.spacing = 0})
      : super(start) {
    digits = [];
    var str = value.toString();
    for (var i = 0; i < str.length; i++) {
      var digit = int.parse(str[i]);
      digits.add(Digit(
          digit, ui.Offset(start.dx + (digitSize.dx + spacing) * i, start.dy),
          outlineColor: outlineColor, size: digitSize));
    }
  }

  @override
  void accept(ShapeVisitor visitor) {}

  @override
  void draw(Uint8List pixels, ui.Size size, {bool antiAlias = false}) {
    for (var digit in digits) {
      digit.draw(pixels, size, antiAlias: antiAlias);
    }
  }
}
