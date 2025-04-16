import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  static double _scale = 1.0;

  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    required this.backgroundColor,
  });

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
        child: ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          icon: Icon(icon, size: 30, color: Colors.white),
          label: Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void _onTapDown(BuildContext context) {
    _updateScale(context, 0.9);
  }

  void _onTapUp(BuildContext context) {
    _updateScale(context, 1.0);
  }

  void _onTapCancel(BuildContext context) {
    _updateScale(context, 1.0);
  }

  void _updateScale(BuildContext context, double newScale) {
    (context as Element).markNeedsBuild();
    _scale = newScale;
  }
}
