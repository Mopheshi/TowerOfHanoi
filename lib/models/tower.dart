import 'disk.dart';

/// Represents a tower in the Tower of Hanoi game.
///
/// This class manages a stack of disks on a tower and provides methods for adding
/// and removing disks, as well as checking if a disk can be placed on the tower
/// based on size constraints.
///
/// **Properties:**
/// - [disks]: The list of [Disk] objects currently on the tower.
///
/// **Methods:**
/// - Methods for adding/removing disks and validating moves.
class Tower {
  final int id;
  final List<Disk> disks;

  Tower({required this.id, List<Disk>? disks}) : disks = disks ?? [];

  Tower copyWith({List<Disk>? disks}) =>
      Tower(id: id, disks: disks ?? List.from(this.disks));

  Disk? get topDisk => disks.isNotEmpty ? disks.last : null;

  bool canAcceptDisk(Disk disk) => disks.isEmpty || disks.last.size > disk.size;

  Tower addDisk(Disk disk) {
    final newDisks = List<Disk>.from(disks)..add(disk);
    return copyWith(disks: newDisks);
  }

  Tower removeDisk() {
    if (disks.isEmpty) return this;

    final newDisks = List<Disk>.from(disks)..removeLast();
    return copyWith(disks: newDisks);
  }
}
