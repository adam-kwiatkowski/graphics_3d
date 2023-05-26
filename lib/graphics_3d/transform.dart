import 'package:graphics_3d/math_3d/matrix.dart';
import 'package:graphics_3d/math_3d/vector3.dart';
import 'package:graphics_3d/math_3d/vector4.dart';

class Transform {
  Vector3 localPosition = Vector3(0, 0, 0);
  Vector3 position = Vector3(0, 0, 0);
  Vector3 rotation = Vector3(0, 0, 0);
  Vector3 scale = Vector3(1, 1, 1);

  Vector4 transformPoint(Vector4 point) {
    Matrix translation = TranslationMatrix(position.x, position.y, position.z);
    Matrix rotation =
        RotationMatrix(this.rotation.x, this.rotation.y, this.rotation.z);
    Matrix scaling = ScaleMatrix(scale.x, scale.y, scale.z);

    return translation
        .dot(rotation)
        .dot(scaling)
        .dot(point.toMatrix())
        .toVector4();
  }

  @override
  String toString() {
    return 'Transform{localPosition: $localPosition, position: $position, rotation: $rotation, scale: $scale}';
  }
}
