import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'rules_notifier.dart';

final rulesProvider = StateNotifierProvider<RulesNotifier, bool>(
  (ref) => RulesNotifier(),
);
