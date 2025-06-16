import 'package:flutter/material.dart';

class SocialIconButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onTap;

  const SocialIconButton({
    super.key,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Image.asset(iconPath, height: 40),
      ),
    );
  }
}
