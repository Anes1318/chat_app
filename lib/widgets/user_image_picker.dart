import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File selectedImage) funkcija;
  const UserImagePicker({required this.funkcija});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? selectedImage;
  void _pickImage() async {
    final picker = ImagePicker();

    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage == null) {
      return;
    }

    final pickedImageFile = File(pickedImage.path);
    setState(() {
      selectedImage = pickedImageFile;
    });
    widget.funkcija(selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: selectedImage == null ? null : FileImage(selectedImage!),
        ),
        TextButton.icon(
          icon: Icon(Icons.camera_alt_outlined),
          label: Text('Pick an image'),
          onPressed: _pickImage,
        ),
      ],
    );
  }
}
