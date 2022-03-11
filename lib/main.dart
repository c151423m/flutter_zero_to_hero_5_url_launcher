import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

const String _url = 'https://google.com';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<XFile>? _imageFileList;
  bool isVideo = false;
  final ImagePicker _picker = ImagePicker();
  void _launchURL() async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  void _getImagePicker(ImageSource source, {BuildContext? context}) async {
    try {
      if (isVideo) {
      } else {
        final pickedFile = await _picker.pickImage(source: source);
        setState(
          () {
            _imageFileList = pickedFile == null ? null : [pickedFile];
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _getMultipleImagePicker(ImageSource source,
      {BuildContext? context}) async {
    try {
      final pickedMultiFile = await _picker.pickMultiImage();
      setState(() {
        _imageFileList = pickedMultiFile == null ? null : pickedMultiFile;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Widget _previewImages() {
    try {
      if (_imageFileList != null) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return Image.file(
              File(_imageFileList![index].path),
            );
          },
          itemCount: _imageFileList!.length,
        );
      } else {
        return const Text("You Need to Pick an Image");
      }
    } catch (e) {
      return Text(
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Packages'),
      ),
      body: Center(
        child: _previewImages(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // _getImagePicker(ImageSource.gallery, context: context);
              _getMultipleImagePicker(ImageSource.gallery, context: context);
            },
            child: Icon(Icons.book),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: FloatingActionButton(
              onPressed: () {
                isVideo = false;
                _getImagePicker(ImageSource.camera, context: context);
              },
              child: Icon(Icons.camera),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: FloatingActionButton(
              onPressed: () {
                isVideo = false;
                _getImagePicker(ImageSource.gallery, context: context);
              },
              child: Icon(Icons.image),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: FloatingActionButton(
              onPressed: _launchURL,
              child: Icon(Icons.network_wifi),
            ),
          ),
        ],
      ),
    );
  }
}
