import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const CircleButton({super.key, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            color: onPressed != null ? Colors.blue : Colors.grey,
            shape: BoxShape.circle,
          ),
          width: 40,
          height: 40,
          child: Icon(icon, size: 30, color: Colors.white),
        ),
      ),
    );
  }
}
