import 'package:flutter/material.dart';

class Zoom extends StatefulWidget {

  @override
  _ZoomState createState() => _ZoomState();
}

  class _ZoomState extends State<Zoom> {
    @override
    Widget build(BuildContext context) {
      return Center(
    child: InteractiveViewer(
    boundaryMargin: const EdgeInsets.all(20.0),
    minScale: 0.1,
    maxScale: 1.6,
    child: Container(
    decoration: const BoxDecoration(
    gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Colors.orange, Colors.red],
    stops: <double>[0.0, 1.0],
    ),
    ),
    ),
    ),
    );


  }
}
