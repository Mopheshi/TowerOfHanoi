import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/rules_provider.dart';
import '../utils/utils.dart';
import 'widgets.dart';

class RulesDialog extends ConsumerWidget {
  const RulesDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Colors.transparent,
      elevation: 20,
      child: CustomContainer(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Game Rules',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              MarkdownBody(
                data: gameRules,
                styleSheet: MarkdownStyleSheet(
                  h1: const TextStyle(
                    color: Colours.yellowColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  h2: const TextStyle(
                    color: Colours.orangeColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  p: TextStyle(
                    color: Colors.white.withAlpha(204),
                    fontSize: 16,
                  ),
                  strong: const TextStyle(
                    color: Colors.cyan,
                    fontWeight: FontWeight.bold,
                  ),
                  listBullet: const TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                  ),
                  blockSpacing: 16.0,
                ),
              ),
              const SizedBox(height: 24),
              ActionButton(
                icon: Icons.check_circle_rounded,
                label: 'I Understand',
                onPressed: () {
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
