import 'package:flutter/material.dart';

import '../models/disk.dart';

class DiskWidget extends StatelessWidget {
  final Disk disk;
  final bool isTop;
  final bool isSelected;
  final int totalDisks;

  const DiskWidget({
    super.key,
    required this.disk,
    required this.isTop,
    required this.isSelected,
    required this.totalDisks,
  });

  /// Renders a disk with animations for selection.
  ///
  /// This method builds the visual representation of a single disk, including its
  /// size, color, and selection state. It incorporates animations to visually
  /// indicate when the disk is part of a selected tower.
  ///
  /// **Parameters:**
  /// - [context]: The build context used for rendering the widget.
  ///
  /// **Returns:**
  /// - A [Widget] representing the disk with its visual properties.
  @override
  Widget build(BuildContext context) {
    final maxWidth = 130.0;
    final minWidth = 40.0;
    final sizeFactor = disk.size / 7;
    final width = minWidth + (maxWidth - minWidth) * sizeFactor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutBack,
      height: 25,
      width: width,
      margin: EdgeInsets.only(bottom: isTop ? 0 : 4, left: 8, right: 8),
      transform:
          isSelected
              ? Matrix4.translationValues(0, -20, 0)
              : Matrix4.identity(),
      decoration: BoxDecoration(
        color: disk.color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(76),
            offset: const Offset(0, 3),
            blurRadius: 4,
          ),
          BoxShadow(
            color: isSelected ? Colors.white.withAlpha(76) : Colors.transparent,
            blurRadius: isSelected ? 8 : 0,
            spreadRadius: isSelected ? 1 : 0,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [disk.color.withAlpha(204), disk.color],
        ),
      ),
    );
  }
}
