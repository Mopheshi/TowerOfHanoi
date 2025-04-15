import 'package:flutter/material.dart';

/// Represents a disk in the Tower of Hanoi game.
///
/// This class defines the properties of a disk, including its [size] and [color],
/// which are used to differentiate disks visually and enforce game rules.
///
/// **Properties:**
/// - [size]: The size of the disk (larger numbers indicate larger disks).
/// - [color]: The color used to render the disk in the UI.
class Disk {
  final int size;
  final Color color;

  const Disk({required this.size, required this.color});

  @override
  String toString() => 'Disk(size: $size)';
}
