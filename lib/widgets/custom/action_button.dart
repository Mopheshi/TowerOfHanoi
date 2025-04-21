import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.backgroundColor = Colours.greenColor,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  double _scale = 1.0;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final baseColors = [
      Color.lerp(widget.backgroundColor, Colors.white, 0.3)!,
      widget.backgroundColor!,
    ];
    final colors =
        _isPressed
            ? baseColors.map((c) => Color.lerp(c, Colors.black, 0.1)!).toList()
            : baseColors;

    return GestureDetector(
      onTapDown:
          (_) => setState(() {
            _scale = 0.9;
            _isPressed = true;
          }),
      onTapUp:
          (_) => setState(() {
            _scale = 1.0;
            _isPressed = false;
          }),
      onTapCancel:
          () => setState(() {
            _scale = 1.0;
            _isPressed = false;
          }),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(51),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.icon, size: 30, color: Colors.white),
                      w8,
                      Text(
                        widget.label,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
