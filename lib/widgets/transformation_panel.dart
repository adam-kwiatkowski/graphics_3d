import 'package:flutter/material.dart';
import 'package:graphics_3d/graphics_3d/transform.dart' as graphics_3d;
import 'package:graphics_3d/math_3d/vector3.dart';

class TransformationPanel extends StatefulWidget {
  final graphics_3d.Transform transform;
  final Function(graphics_3d.Transform) onTransformChanged;

  const TransformationPanel(
      {super.key, required this.transform, required this.onTransformChanged});

  @override
  State<TransformationPanel> createState() => _TransformationPanelState();
}

class Item {
  final String title;
  bool isExpanded;
  Vector3 vector;
  int index = 0;

  Item(this.title, this.isExpanded, this.vector, [this.index = 0]);
}

class _TransformationPanelState extends State<TransformationPanel> {
  late List<Item> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      Item('Local Position', false, widget.transform.localPosition, 0),
      Item('Position', false, widget.transform.position, 1),
      Item('Rotation', false, widget.transform.rotation, 2),
      Item('Scale', false, widget.transform.scale, 3),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: _buildPanel(),
    );
  }

  Widget _buildPanel() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('Transform',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _items[index].isExpanded = !isExpanded;
                });
              },
              children: _items.map<ExpansionPanel>((Item item) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(item.title),
                    );
                  },
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 16, 32),
                    child: Column(
                      children: [
                        _buildVectorInput('X', item.vector, 0, item.index),
                        _buildVectorInput('Y', item.vector, 1, item.index),
                        _buildVectorInput('Z', item.vector, 2, item.index),
                      ],
                    ),
                  ),
                  isExpanded: item.isExpanded,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVectorInput(
      String label, Vector3 vector, int index, int valueIndex) {
    return Row(
      children: [
        const SizedBox(width: 16.0),
        Text('$label: '),
        const SizedBox(width: 16.0),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            initialValue: vector[index].toString(),
            decoration: const InputDecoration(
              labelText: 'Enter a value',
            ),
            onChanged: (value) {
              setState(() {
                vector[index] = double.tryParse(value) ?? 0.0;
                widget.onTransformChanged(_updateTransform(valueIndex, vector));
              });
            },
          ),
        ),
      ],
    );
  }

  graphics_3d.Transform _updateTransform(int index, Vector3 vector) {
    switch (index) {
      case 0:
        widget.transform.localPosition = vector;
        return widget.transform;
      case 1:
        widget.transform.position = vector;
        return widget.transform;
      case 2:
        widget.transform.rotation = vector;
        return widget.transform;
      case 3:
        widget.transform.scale = vector;
        return widget.transform;
      default:
        return widget.transform;
    }
  }
}
