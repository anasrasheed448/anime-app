// Package imports:
import 'dart:io';

import 'package:http/http.dart' as http;

// A shitty cacher for http requests, works perfect for this project
class CachedHttpGet {
  static Map<Request, String> cache = {};

  static Future<String> get(Request req, [Exception customException]) async {
    if (cache.keys.contains(req)) return cache[req];

    var response = await http.get(
      req.url,
      headers: req.header,
    );

    if (response.statusCode == HttpStatus.ok) {
      cache[req] = response.body;
    } else {
      if (customException == null) throw Exception();
      throw customException;
    }

    return response.body;
  }
}

class Request {
  final String url;
  final Map<String, String> header;

  Request({this.url, this.header});

  @override
  bool operator ==(covariant Request req) {
    if (identical(this, req)) return true;

    return (req.url == url && req.header.toString() == header.toString());
  }

  @override
  int get hashCode => url.hashCode;
}
