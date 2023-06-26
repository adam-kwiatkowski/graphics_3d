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
              Row(
                children: [
                  Text('Texture: ${object.texture}'),
                  const SizedBox(width: 8),
                  if (object.texture != null)
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(8),
                        minimumSize: const Size(0, 0),
                        foregroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Remove',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        object.texture = null;
                        onObjectChanged(object);
                      },
                    )
                ],
              ),

              Row(
                  children: [
                    const Text('Visible'),
                    Transform.scale(
                      scale: 0.5,
                      child: Switch(
                        value: object.visible,
                        onChanged: (value) {
                          object.visible = value;
                          onObjectChanged(object);
                        },
                      ),
                    ),
                  ]
              ),
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
