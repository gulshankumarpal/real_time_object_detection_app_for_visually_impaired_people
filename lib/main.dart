import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:live_object_detection/home_page.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Object Detector',
      home: HomePage(cameras),
      debugShowCheckedModeBanner: false,
    );
  }
}

