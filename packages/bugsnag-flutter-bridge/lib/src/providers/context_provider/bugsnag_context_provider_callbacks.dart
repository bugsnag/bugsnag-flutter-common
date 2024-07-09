import 'package:bugsnag_bridge/src/providers/context_provider/bugsnag_context_provider.dart';

typedef BugsnagTraceContextCallback = BugsnagTraceContext? Function();

class BugsnagContextProviderCallbacks {
  BugsnagTraceContextCallback? _currentTraceContextCallback;

  BugsnagTraceContext? getCurrentTraceContext() {
    final callback = _currentTraceContextCallback;
    if (callback == null) {
      return null;
    }
    return callback();
  }

  static setup({
    BugsnagTraceContextCallback? currentTraceContextCallback,
  }) {
    if (currentTraceContextCallback != null) {
      bugsnagContextProviderCallbacks._currentTraceContextCallback =
          currentTraceContextCallback;
    }
  }
}

final bugsnagContextProviderCallbacks = BugsnagContextProviderCallbacks();
