import 'dart:io' show File;

import 'package:flutter/material.dart';

class FullImageScreen extends StatelessWidget {
  final File image;

  const FullImageScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context), // go out when clicked
        child: Center(
          child: Hero(
            tag: "profile_image",
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4,
              child: Image.file(image),
            ),
          ),
        ),
      ),
    );
  }
}
