import 'package:flutter/material.dart';
import 'package:graphics_3d/graphics_3d/transform.dart' as t;
import 'package:graphics_3d/math_3d/vector3.dart';

class TransformationPanel extends StatefulWidget {
  final t.Transform transform;
  final String title;
  final Function(t.Transform) onTransformChanged;

  const TransformationPanel(
      {super.key, required this.transform, required this.onTransformChanged, this.title = 'Transform'});

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
    return _buildPanel();
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
              child: Text(widget.title,
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
                        VectorInput(label: 'X', item: item, onChanged: (vector) {
                          widget.onTransformChanged(_updateTransform(item.index, vector));
                        }, index: 0),
                        VectorInput(label: 'Y', item: item, onChanged: (vector) {
                          widget.onTransformChanged(_updateTransform(item.index, vector));
                        }, index: 1),
                        VectorInput(label: 'Z', item: item, onChanged: (vector) {
                          widget.onTransformChanged(_updateTransform(item.index, vector));
                        }, index: 2),
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

  t.Transform _updateTransform(int index, Vector3 vector) {
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

class VectorInput extends StatefulWidget {
  final String label;
  final Item item;
  final int index;
  final Function(Vector3) onChanged;

  const VectorInput({Key? key, required this.label, required this.item, required this.onChanged, required this.index}) : super(key: key);

  @override
  State<VectorInput> createState() => _VectorInputState();
}

class _VectorInputState extends State<VectorInput> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.item.vector[widget.index].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 16.0),
        Text('${widget.label}: '),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Enter a value',
                ),
                onChanged: (value) {
                  setState(() {
                    widget.item.vector[widget.index] = double.tryParse(value) ?? 0.0;
                    widget.onChanged(widget.item.vector);
                  });
                },
              ),
              const SizedBox(height: 16.0),
              Slider(value: widget.item.vector[widget.index], onChanged: (value) {
                setState(() {
                  widget.item.vector[widget.index] = value;
                  controller.text = value.toString();
                  widget.onChanged(widget.item.vector);
                });
              }, min: -1000, max: 1000,)
            ],
          ),
        ),
      ],
    );
  }
}
