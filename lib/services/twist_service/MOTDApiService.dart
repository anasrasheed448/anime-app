// Message of the day utils

// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:anime_twist_flut/cached_http_get/CachedHttpGet.dart';
import 'package:anime_twist_flut/services/CacheService.dart';
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import 'package:anime_twist_flut/utils/JsonUtils.dart';
import 'package:flutter/foundation.dart';
import 'package:supercharged/supercharged.dart';

// Project imports:
import '../../secrets.dart';

class MOTDApiService {
  static Future<List<String>> getMOTD() async {
    var cacheService = CacheService(
      '/data/motd',
      7.days,
    );

    await cacheService.initialize(false);
    var response = await cacheService.getDataAndCacheIfNeeded(
      getData: () async {
        return await CachedHttpGet.get(
          Request(
            url: TwistApiService.BASE_API_URL + '/motd',
            header: {
              'x-access-token': x_access_token,
            },
          ),
        );
      },
      onCache: () {},
      onSkipCache: () {},
      willUpdateCache: (cachedData, __) async {
        return !JsonUtils.isValidJson(cachedData);
      },
    );

    return await compute(_computeData, response);
  }

  static String _parseMOTD(String motd) {
    var exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);

    return motd.replaceAll(exp, '');
  }

  static Future<List<String>> _computeData(String data) async {
    var ret = <String>[];
    Map<String, dynamic> jsonData = jsonDecode(data);

    ret.add(jsonData['title']);
    ret.add(_parseMOTD(jsonData['message']));
    return ret;
  }
}
