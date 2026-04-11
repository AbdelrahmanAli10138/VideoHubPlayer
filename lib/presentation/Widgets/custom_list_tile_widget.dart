import 'package:flutter/material.dart';
import 'package:video_hub/core/Themes/app_theme.dart';

class CustomListTile extends StatelessWidget {
  CustomListTile({
    super.key,
    required this.leading,
    required this.trailing,
    required this.title,
  });
  final Icon leading;
  final Icon trailing;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: trailing,
    );
  }
}
