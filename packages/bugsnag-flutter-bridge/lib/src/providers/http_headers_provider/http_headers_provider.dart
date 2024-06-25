import 'http_headers_provider_callbacks.dart';

abstract class HttpHeadersProvider {
  Map<String, String>? requestHeaders({
    required String url,
    required String requestId,
  });
}

class HttpHeadersProviderImpl implements HttpHeadersProvider {
  @override
  Map<String, String>? requestHeaders({
    required String url,
    required String requestId,
  }) {
    return httpHeadersProviderCallbacks.getRequestHeaders(
      url: url,
      requestId: requestId,
    );
  }
}
