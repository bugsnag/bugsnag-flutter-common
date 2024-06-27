import 'package:bugsnag_bridge/src/providers/context_provider/bugsnag_context_provider_callbacks.dart';

class BugsnagSpanContext {
  final String spanId;
  final String traceId;

  BugsnagSpanContext({
    required this.spanId,
    required this.traceId,
  });
}

abstract class BugsnagContextProvider {
  BugsnagSpanContext? getCurrentSpanContext();
}

class BugsnagContextProviderImpl implements BugsnagContextProvider {
  @override
  BugsnagSpanContext? getCurrentSpanContext() {
    return bugsnagContextProviderCallbacks.getCurrentSpanContext();
  }
}
