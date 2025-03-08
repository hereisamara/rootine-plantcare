import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageViewer {
  ImageViewer._();

  static show({
    required BuildContext context,
    required String assetPath,
    BoxFit? fit,
    double? radius,
  }) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          image: DecorationImage(image: AssetImage(assetPath), fit: fit ?? BoxFit.cover),
        ),
      ),
    );
  }
}
