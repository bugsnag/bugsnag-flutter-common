import 'package:bugsnag_bridge/src/providers/context_provider/bugsnag_context_provider.dart';

typedef BugsnagSpanContextCallback = BugsnagSpanContext? Function();

class BugsnagContextProviderCallbacks {
  BugsnagSpanContextCallback? _currentSpanContextCallback;

  BugsnagSpanContext? getCurrentSpanContext() {
    final callback = _currentSpanContextCallback;
    if (callback == null) {
      return null;
    }
    return callback();
  }

  static setup({
    BugsnagSpanContextCallback? currentSpanContextCallback,
  }) {
    if (currentSpanContextCallback != null) {
      bugsnagContextProviderCallbacks._currentSpanContextCallback =
          currentSpanContextCallback;
    }
  }
}

final bugsnagContextProviderCallbacks = BugsnagContextProviderCallbacks();
