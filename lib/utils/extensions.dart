extension TimeFormatting on int {
  String formatTime() {
    final mins = this ~/ 60;
    final secs = this % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}