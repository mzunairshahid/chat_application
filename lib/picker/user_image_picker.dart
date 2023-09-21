import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;

  UserImagePicker(this.imagePickFn);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  Future<void> _pickImage() async {
    final pickedImageFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    if (pickedImageFile == null) {
      return;
    }
    final pickedImage =
        File(pickedImageFile.path); // Convert PickedFile to File
    setState(() {
      _pickedImage = pickedImage;
    });
    widget.imagePickFn(pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(
            Icons.image,
          ),
          label: Text('Add image'),
        )
      ],
    );
  }
}
