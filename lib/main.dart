import 'package:flutter/material.dart';
import 'package:graphics_3d/cube.dart';

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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints.expand(),
          child: RotatingCube(
            // cube: Cube([
            //   AffinePoint(-100, -100, -100, 1),
            //   AffinePoint(100, -100, -100, 1),
            //   AffinePoint(100, 100, -100, 1),
            //   AffinePoint(-100, 100, -100, 1),
            //   AffinePoint(-100, -100, 100, 1),
            //   AffinePoint(100, -100, 100, 1),
            //   AffinePoint(100, 100, 100, 1),
            //   AffinePoint(-100, 100, 100, 1),
            // ]),
            cube: Cube.centered(200, AffinePoint(0, 0, 0, 1)),
          ),
        ),
      ),
    );
  }
}

