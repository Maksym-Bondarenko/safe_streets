import 'package:riverpod/src/notifier.dart' as notifier;

// ignore: invalid_use_of_internal_member
mixin SetProvider<T> on notifier.NotifierBase<T> {
  void set(T newState) {
    state = newState;
  }
}
