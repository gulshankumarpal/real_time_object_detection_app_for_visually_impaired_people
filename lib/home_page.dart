import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'camera.dart';
import 'box.dart';
import 'models.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePage(this.cameras);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recognitions = [];
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  @override
  void initState() {
    super.initState();
  }

  loadModel() async {
    String res;
    switch (_model) {
      case yolo:
        res = (await Tflite.loadModel(
          model: "assets/yolov2_tiny.tflite",
          labels: "assets/yolov2_tiny.txt",
        ))!;
        break;

      default:
        res = (await Tflite.loadModel(
            model: "assets/ssd_mobilenet.tflite",
            labels: "assets/ssd_mobilenet.txt"))!;
    }
    //print(res);
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Object Detection'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: _model == ""
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Image(
                    image: AssetImage('assets/blind.png'),
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 50,
                    width: 100,
                  ),
                  OutlinedButton(
                    child: const Text(
                      ssd,
                      style: TextStyle(
                          fontSize: 18, color: Colors.deepPurpleAccent),
                    ),
                    style: OutlinedButton.styleFrom(
                      primary: Colors.deepPurple,
                      side: const BorderSide(
                          color: Colors.deepPurpleAccent, width: 2),
                    ),
                    onPressed: () => onSelect(ssd),
                  ),
                  const SizedBox(
                    height: 20,
                    width: 100,
                  ),
                  RaisedButton(
                    child: const Text(
                      yolo,
                      style: TextStyle(fontSize: 18),
                    ),
                    color: Colors.deepPurpleAccent,
                    textColor: Colors.white,
                    onPressed: () => onSelect(yolo),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                Camera(
                  widget.cameras,
                  _model,
                  setRecognitions,
                ),
                Box(
                    _recognitions,
                    math.max(_imageHeight, _imageWidth),
                    math.min(_imageHeight, _imageWidth),
                    screen.height,
                    screen.width,
                    _model),
              ],
            ),
    );
  }
}
