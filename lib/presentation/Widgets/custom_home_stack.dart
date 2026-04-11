import 'package:flutter/material.dart';

class CustomHomeStack extends StatelessWidget {
  const CustomHomeStack({
    super.key,
    required this.backgroundColor,
    required this.positionedicon,
    required this.positionedString,
    required this.stringColor,
    required this.onTap,
  });

  final Color backgroundColor;
  final Icon positionedicon;
  final String positionedString;
  final Color stringColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,

      child: Container(
        height: size.height * 0.18,
        width: size.width * 0.42,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(size.width * 0.05),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              positionedicon,
              const SizedBox(height: 8),
              Text(
                positionedString,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: stringColor,
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.035, // responsive font
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
