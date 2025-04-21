const String appName = "Tower of Hanoi";

const String imagesPath = "assets/images/";
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

// Image assets
const String appIcon = "${imagesPath}ic_launcher.png";

// Constants
const int minDiskCount = 3;
const int maxDiskCount = 7;

// Game Strings
const String gameRules = """
# How to Play
---
## $appName
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
""";

const String aboutApp = """
# About $appName
---
## What is $appName?
The **$appName** is a classic puzzle game where the goal is to move all disks from one tower to another, following specific rules.

## Features
- Interactive gameplay
- Auto-solve functionality
- Adjustable difficulty
- Performance tracking
- Immersive audio

## How to Play
1. Move disks one at a time.
2. Follow the rules: larger disks cannot be placed on smaller ones.
3. Solve the puzzle to win!

Enjoy the game and challenge yourself!
""";
