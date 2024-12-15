//Widget which allows the user to open the devices camera, take a picture, and other related functionality

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File image)
      onPickImage; //function that is used to store the image selected by the user

  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File?
      _selectedImage; //variable to represent the actual image taken by the user
  void _takePicture() async {
    //opens the camera and then captures an image
    final imagePicker =
        ImagePicker(); //utility object added to the codebase via the ImagePicker library
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    ); //opens up the android devices camera
    if (pickedImage == null) {
      //user did not end up taking a photo
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    }); //converts path to a File object type
    widget.onPickImage(
        _selectedImage!); //forwards picture to the widget using the function
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      //conditional content
      icon: const Icon(Icons.camera),
      label: const Text('Take Picture'),
      onPressed: _takePicture,
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap:
            _takePicture, //allows you to retake image if you tap on the taken picture
        child: Image.file(_selectedImage!,
            fit: BoxFit.cover, width: double.infinity, height: double.infinity),
      );
    }
    return Container(
      decoration: BoxDecoration(
        //adds a colored border around the Take Picture Button
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    ); //Allows user to take a picture by pressing a button
  }
}
