import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  static double _scale = 1.0;

  const CircleButton({super.key, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _onTapDown(context),
      onTapUp: (_) => _onTapUp(context),
      onTapCancel: () => _onTapCancel(context),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(30),
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
        ),
      ),
    );
  }

  void _onTapDown(BuildContext context) => _updateScale(context, 0.9);

  void _onTapUp(BuildContext context) => _updateScale(context, 1.0);

  void _onTapCancel(BuildContext context) => _updateScale(context, 1.0);

  void _updateScale(BuildContext context, double newScale) {
    (context as Element).markNeedsBuild();
    _scale = newScale;
  }
}
