const String appName = "Tower of Hanoi";

// const String assetsPath = "assets/";
// const String soundsPath = "sounds/";
const String soundsPath = "assets/sounds/";

// Sound assets
const String selectSound = "${soundsPath}select.mp3";
const String deselectSound = "${soundsPath}deselect.mp3";
const String moveSound = "${soundsPath}move.mp3";
const String errorSound = "${soundsPath}error.mp3";
const String winSound = "${soundsPath}win.mp3";
const String resetSound = "${soundsPath}reset.mp3";
const String clickSound = "${soundsPath}click.mp3";
const String lostSound = "${soundsPath}lost.mp3";
const String backgroundMusic = "${soundsPath}background_music.mp3";

// Constants
const int minDiskCount = 3;
const int maxDiskCount = 7;

// Game Rules
const String gameRules = '''
# How to Play
---
## Tower of Hanoi
---
**Objective**:  
Move all disks from the first tower to the second or third tower.

1. **Start:** All disks begin stacked on the first tower, smallest on top.
2. **Select:** Tap a tower to pick its top disk (if any).
3. **Move:** Tap another tower to place the disk, following the rules.
4. **Win:** Move all disks to the second or third tower to claim victory!
5. **Auto-Solve:** Hit the "Auto Solve" button to see the solution in action.
6. **Reset:** Tap "Reset" to restart with the same disk count.
7. **Adjust Difficulty:** Use "+" and "-" buttons to change the number of disks.
''';
