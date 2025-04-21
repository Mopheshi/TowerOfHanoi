import 'package:flutter/material.dart';

class CircleButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const CircleButton({super.key, required this.icon, this.onPressed});

  @override
  State<CircleButton> createState() => _CircleButtonState();
}

class _CircleButtonState extends State<CircleButton> {
  double _scale = 1.0;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final baseColors =
        widget.onPressed != null
            ? [Colors.blue.shade200, Colors.blue.shade900]
            : [Colors.grey.shade400, Theme.of(context).colorScheme.surfaceDim];
    final colors =
        _isPressed
            ? baseColors.map((c) => Color.lerp(c, Colors.black, 0.1)!).toList()
            : baseColors;

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _scale = 0.9;
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _scale = 1.0;
          _isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _scale = 1.0;
          _isPressed = false;
        });
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(30),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(51),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              width: 40,
              height: 40,
              child: Icon(widget.icon, size: 30, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
