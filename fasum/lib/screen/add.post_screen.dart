import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  File? _image;
  String? _base64Image;

  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  bool _isUploading = false;
  double? _latitude;
  double? _longitude;


  Future<void> _pickImage(ImageSource source) async {
    final PickedFile =await _picker.pickImage(source: source);
    if(PickedFile != null) {
      setState(() {
        _image = File(PickedFile.path);
      });
      await _compressAndEncodeImage();
    }
  }

  Future<void> _compressAndEncodeImage() async {
    if(_image == null) {
      final compressedImage = await FlutterImageCompress.compressWithFile(_image!.path, quality: 50);
      if(compressedImage == null) return;
      setState(() {
        _base64Image = base64Encode(compressedImage);
      });
    }
  }

  Future<void> _getLocation() async {
    bool serviceEnable;
    LocationPermission permission;

    serviceEnable = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnable) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        throw Exception('Location permission are denied.');
      }
    }

    try {
      final Position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 10));
      setState(() {
        _latitude = null;
        _longitude = null;
      });
    } catch (e) {
      setState(() {
        debugPrint('Failed to retrive location: $e');

        _latitude = null;
        _longitude = null;
      });
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Post')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _image != null ? Image.file(
              _image!, 
              height: 200, 
              width: double.infinity, 
              fit: BoxFit.cover) 
              : GestureDetector()
          ],
        ),
      ),
    );
  }
}