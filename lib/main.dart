import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:graphics_3d/graphics_3d/cuboid.dart';
import 'package:graphics_3d/graphics_3d/cylinder.dart';
import 'package:graphics_3d/graphics_3d/object_3d.dart';
import 'package:graphics_3d/graphics_3d/plane.dart';
import 'package:graphics_3d/graphics_3d/texture.dart' as g3;
import 'package:graphics_3d/math_3d/vector3.dart';
import 'package:graphics_3d/widgets/widget_3d.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3D Graphics',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '3D Graphics'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Object3D> objects = [
    Object3D(Cuboid(100, 100, 100, Vector3(300, 0, 0))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
            constraints: const BoxConstraints.expand(),
            child: TexturedCylinder(
                radius: 80, height: 300, sides: 40, otherObjects: objects)),
      ),
    );
  }
}

class TexturedCylinder extends StatefulWidget {
  const TexturedCylinder(
      {super.key,
      required this.radius,
      required this.height,
      required this.sides,
      required this.otherObjects});

  final List<Object3D> otherObjects;
  final double radius;
  final double height;
  final int sides;

  @override
  State<TexturedCylinder> createState() => _TexturedCylinderState();
}

class _TexturedCylinderState extends State<TexturedCylinder> {
  late Object3D cylinder;
  late Object3D cube;
  late Object3D plane;
  XFile? image;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    cylinder = Object3D(Cylinder(widget.radius, widget.height, widget.sides,
        Vector3(100, -150, -200)));
    cube = Object3D(Cuboid(100, 100, 100, Vector3(320, -200, 0)));
    plane = Object3D(Plane(100, 100, Vector3(100, -240, 0)));

    cylinder.mesh.transform.rotation = Vector3(-0.58, 2.28, 0);
    cube.mesh.transform.rotation = Vector3(-0.5463, -0.5463, 0);
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragEntered: (details) {
        setState(() {
          isDragging = true;
        });
      },
      onDragExited: (details) {
        setState(() {
          isDragging = false;
        });
      },
      onDragDone: (details) async {
        setState(() {
          isDragging = false;
        });
        image = details.files.first;
        var bytes = await image!.readAsBytes();
        decodeImageFromList(bytes).then((image) {
          var width = image.width;
          var height = image.height;
          image.toByteData().then((data) {
            var texture = g3.Texture(data!.buffer.asUint8List(), width, height);
            setState(() {
              cylinder.texture = texture;
              cube.texture = texture;
              plane.texture = texture;
            });
          });
        });
      },
      child: Renderer3D(objects: widget.otherObjects + [
        cylinder,
        cube,
        plane
      ]),
    );
  }
}
