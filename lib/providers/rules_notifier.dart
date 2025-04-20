import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RulesNotifier extends StateNotifier<bool> {
  RulesNotifier() : super(true) {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('rulesAccepted') ?? false;
  }

  Future<void> acceptRules() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rulesAccepted', true);
    state = true;
  }
}
