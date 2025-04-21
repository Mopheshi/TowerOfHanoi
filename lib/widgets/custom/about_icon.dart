import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../utils/utils.dart';
import '../widgets.dart';

class AboutIcon extends StatelessWidget {
  const AboutIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 30,
      tooltip: 'About $appName',
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder:
            (child, animation) =>
                ScaleTransition(scale: animation, child: child),
        child: Icon(Icons.info_rounded, key: ValueKey('about')),
      ),
      onPressed: () async {
        GameAudioPlayer.playEffect(GameSounds.click);
        final packageInfo = await PackageInfo.fromPlatform();
        if (!context.mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.transparent,
                elevation: 20,
                child: GradientContainer(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Image.asset(appIcon, width: 50, height: 50),
                            w16,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  packageInfo.appName,
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                                Text(packageInfo.version),
                              ],
                            ),
                          ],
                        ),
                        h16,
                        MarkdownText(text: aboutApp),
                        h24,
                        ActionButton(
                          icon: Icons.check_circle_rounded,
                          label: 'Close',
                          onPressed: () {
                            GameAudioPlayer.playEffect(GameSounds.click);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        );
      },
    );
  }
}
