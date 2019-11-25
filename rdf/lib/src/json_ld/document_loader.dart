import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class DocumentLoader {
  final http.Client httpClient;
  var _cache = <Uri, _CachedResponse>{};

  DocumentLoader({http.Client httpClient})
      : this.httpClient = httpClient ?? http.Client();

  Future<Object> dereference(Uri url) async {
    // TODO: Throw errors
    var response = await getUrl(url);
    return json.decode(response.body);
  }

  /// Fetches a resource from the Web; honoring caching headers.
  Future<http.Response> getUrl(Uri url) async {
    var cached = _cache[url];
    var now = DateTime.now();

    // Honor Cache-Control
    if (cached?.expiry != null && now.isBefore(cached.expiry)) {
      return cached.response;
    }

    var headers = cached?.headers ?? {};
    var rs = await httpClient.get(url, headers: headers);
    if (rs.statusCode == 304 && cached != null) {
      return cached.response;
    } else {
      _cache[url] = _CachedResponse(rs, now);
      return rs;
    }
  }
}

class _CachedResponse {
  http.Response response;
  DateTime sentAt;
  DateTime _expiry, _lastModified;

  _CachedResponse(this.response, this.sentAt);

  static final RegExp _maxAge = RegExp(r'(s-)?max-age=([0-9]+)');

  DateTime get expiry {
    if (_expiry != null) {
      return _expiry;
    } else {
      var cacheControl = response.headers['cache-control'];
      var maxAgeMatch = _maxAge.firstMatch(cacheControl ?? '');
      if (maxAgeMatch != null) {
        var seconds = int.parse(maxAgeMatch[2]);
        return _expiry = sentAt.add(Duration(seconds: seconds));
      } else if (response.headers.containsKey('expires')) {
        try {
          return _expiry = parseHttpDate(response.headers['expires']);
        } on FormatException {
          return null;
        }
      } else {
        return null;
      }
    }
  }

  Map<String, String> get headers => {
        'if-none-match': etag,
        'if-modified-since':
            lastModified == null ? null : formatHttpDate(lastModified)
      }..removeWhere((_, v) => v == null);

  String get etag => response.headers['etag'];

  DateTime get lastModified {
    if (_lastModified != null) {
      return _lastModified;
    } else if (response.headers.containsKey('last-modified')) {
      try {
        return _lastModified = parseHttpDate(response.headers['last-modified']);
      } on FormatException {
        return null;
      }
    } else {
      return null;
    }
  }
}
