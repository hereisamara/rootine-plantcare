import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageUploader extends StatelessWidget {
  final String? imageDefaultPath;
  final File? selectedImage;
  final Function pickedImage;

  ImageUploader({
    required this.selectedImage,
    required this.pickedImage,
    this.imageDefaultPath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 262,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: _getImageProvider(),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          child: Container(
            width: double.infinity,
            height: 41,
            decoration: BoxDecoration(color: Color.fromARGB(125, 0, 0, 0)),
            child: IconButton(
              splashRadius: 1,
              onPressed: () {
                pickedImage();
              },
              icon: Icon(
                Icons.file_upload_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  ImageProvider _getImageProvider() {
    if (selectedImage != null) {
      return kIsWeb
          ? NetworkImage(selectedImage!.path)
          : FileImage(File(selectedImage!.path)) as ImageProvider;
    } else if (imageDefaultPath != null && _isUrl(imageDefaultPath!)) {
      return NetworkImage(
        imageDefaultPath!,
        // `errorBuilder` here is used for handling errors and fallback
      );
    } else {
      return AssetImage(imageDefaultPath ?? 'assets/images/plant.png');
    }
  }

  bool _isUrl(String path) {
    return Uri.tryParse(path)?.hasAbsolutePath ?? false;
  }
}
