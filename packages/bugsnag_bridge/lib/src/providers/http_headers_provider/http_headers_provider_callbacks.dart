typedef HttpHeadersCallback = Future<Map<String, String>?> Function(
  String url,
  String requestId,
);

class HttpHeadersProviderCallbacks {
  HttpHeadersCallback? _httpRequestHeadersCallback;

  Future<Map<String, String>?> getRequestHeaders({
    required String url,
    required String requestId,
  }) {
    final callback = _httpRequestHeadersCallback;
    if (callback == null) {
      return Future.value(null);
    }
    return callback(
      url,
      requestId,
    );
  }

  static setup({
    HttpHeadersCallback? httpRequestHeadersCallback,
  }) {
    if (httpRequestHeadersCallback != null) {
      httpHeadersProviderCallbacks._httpRequestHeadersCallback =
          httpRequestHeadersCallback;
    }
  }
}

final httpHeadersProviderCallbacks = HttpHeadersProviderCallbacks();
