import 'package:graphics_3d/graphics_3d/mesh.dart';
import 'package:graphics_3d/graphics_3d/texture.dart';

class Object3D {
  Mesh mesh;
  Texture? texture;
  bool visible = true;

  Object3D(this.mesh, {this.texture});
}
