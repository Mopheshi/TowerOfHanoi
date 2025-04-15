import 'package:flutter/material.dart';
import 'package:tower_of_hanoi/utils/colours.dart';

import '../models/tower.dart';
import 'disk_widget.dart';

class TowerWidget extends StatelessWidget {
  final Tower tower;
  final bool isSelected;
  final double maxHeight;
  final VoidCallback onTap;

  const TowerWidget({
    super.key,
    required this.tower,
    required this.isSelected,
    required this.maxHeight,
    required this.onTap,
  });

  /// Renders a tower with its disks and handles tower selection.
  ///
  /// This method constructs the visual representation of a tower, including the rod,
  /// base, and stacked disks. It also manages the selection state, applying animations
  /// when the tower is selected by the user.
  ///
  /// **Parameters:**
  /// - [context]: The build context used for rendering the widget.
  ///
  /// **Returns:**
  /// - A [Widget] representing the tower and its disks.
  @override
  Widget build(BuildContext context) {
    final diskAreaHeight = maxHeight * 0.75;
    final baseHeight = maxHeight * 0.05;
    final rodWidth = 12.0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform:
            isSelected
                ? Matrix4.translationValues(0, -10, 0)
                : Matrix4.identity(),
        child: OverflowBox(
          maxHeight: maxHeight + 30,
          child: Container(
            width: 150,
            height: maxHeight,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Tower rod
                Positioned(
                  bottom: baseHeight,
                  child: Container(
                    width: rodWidth,
                    height: diskAreaHeight,
                    decoration: BoxDecoration(
                      color: Colours.brownColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(rodWidth / 2),
                        topRight: Radius.circular(rodWidth / 2),
                      ),
                    ),
                  ),
                ),

                // Tower base
                Container(
                  width: 100,
                  height: baseHeight,
                  decoration: BoxDecoration(
                    color: Colours.brownColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),

                // Disks
                Positioned(
                  bottom: baseHeight,
                  child: SizedBox(
                    width: 150,
                    height: diskAreaHeight,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final diskCount = tower.disks.length;
                        if (diskCount == 0) return const SizedBox.shrink();

                        return FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: 150,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children:
                                  tower.disks.reversed.map((disk) {
                                    final isTopDisk = disk == tower.disks.last;
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 4.0,
                                      ),
                                      child: DiskWidget(
                                        // Unique key based on disk size
                                        key: ValueKey(disk.size),
                                        disk: disk,
                                        isTop: isTopDisk,
                                        isSelected: isSelected && isTopDisk,
                                        totalDisks: tower.disks.length,
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
