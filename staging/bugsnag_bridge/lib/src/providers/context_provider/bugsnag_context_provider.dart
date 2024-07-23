import 'package:bugsnag_bridge/src/providers/context_provider/bugsnag_context_provider_callbacks.dart';

class BugsnagTraceContext {
  final String spanId;
  final String traceId;

  BugsnagTraceContext({
    required this.spanId,
    required this.traceId,
  });
}

abstract class BugsnagContextProvider {
  BugsnagTraceContext? getCurrentTraceContext();
}

class BugsnagContextProviderImpl implements BugsnagContextProvider {
  @override
  BugsnagTraceContext? getCurrentTraceContext() {
    return bugsnagContextProviderCallbacks.getCurrentTraceContext();
  }
}
