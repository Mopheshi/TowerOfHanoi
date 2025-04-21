import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/rules_provider.dart';
import '../../utils/utils.dart';
import '../widgets.dart';

class RulesDialog extends ConsumerWidget {
  const RulesDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
                  Text(
                    'Game Rules',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
              h16,
              MarkdownText(text: gameRules),
              h24,
              ActionButton(
                icon: Icons.check_circle_rounded,
                label: 'I Understand',
                onPressed: () {
                  GameAudioPlayer.playEffect(GameSounds.click);
                  ref.read(rulesProvider.notifier).acceptRules();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
