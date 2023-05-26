import 'package:flutter/material.dart';
import 'package:graphics_3d/graphics_3d/object_3d.dart';
import 'package:graphics_3d/widgets/transformation_panel.dart';

class ObjectInfoPanel extends StatelessWidget {
  final Object3D object;
  final Function(Object3D) onObjectChanged;

  const ObjectInfoPanel(
      {super.key, required this.object, required this.onObjectChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${object.mesh}',
                  style: Theme.of(context).textTheme.titleLarge),
              Text('Vertices: ${object.mesh.vertices.length}'),
              Text('Texture: ${object.texture}'),
            ],
          ),
        ),
        TransformationPanel(
            transform: object.mesh.transform,
            onTransformChanged: (t) => {
                  object.mesh.transform = t,
                  onObjectChanged(object),
                }),
      ],
    );
  }
}
