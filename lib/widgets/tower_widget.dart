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

  @override
  Widget build(BuildContext context) {
    final diskAreaHeight = maxHeight * 0.75;
    final baseHeight = maxHeight * 0.06;
    final rodWidth = 15.0;

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
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.lerp(Colours.brownColor, Colors.black, 0.2)!,
                          Color.lerp(Colours.brownColor, Colors.white, 0.2)!,
                          Color.lerp(Colours.brownColor, Colors.black, 0.2)!,
                        ],
                      ),
                      // border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(rodWidth / 2),
                        topRight: Radius.circular(rodWidth / 2),
                      ),
                    ),
                  ),
                ),

                // Tower base
                Container(
                  width: 120,
                  height: baseHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.lerp(Colours.brownColor, Colors.white, 0.15)!,
                        Color.lerp(Colours.brownColor, Colors.black, 0.15)!,
                      ],
                    ),
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(76),
                        offset: Offset(0, 2),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
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
