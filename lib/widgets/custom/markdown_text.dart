import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../utils/colours.dart';

class MarkdownText extends StatelessWidget {
  final String text;

  const MarkdownText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: text,
      styleSheet: MarkdownStyleSheet(
        h1: Theme.of(
          context,
        ).textTheme.displayMedium?.copyWith(color: Colours.yellowColor),
        h2: Theme.of(
          context,
        ).textTheme.displaySmall?.copyWith(color: Colours.orangeColor),
        p: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(color: Colors.white.withAlpha(204)),
        strong: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Colors.cyan,
          fontWeight: FontWeight.bold,
        ),
        listBullet: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(color: Colours.greenColor),
        blockSpacing: 16.0,
      ),
    );
  }
}
