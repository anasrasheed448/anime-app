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

class DonationApiService {
  static Future<List<int>> getDonations() async {
    var cacheService = CacheService(
      '/data/donation',
      3.days,
    );

    await cacheService.initialize(false);
    var response = await cacheService.getDataAndCacheIfNeeded(
      getData: () async {
        return await CachedHttpGet.get(
          Request(
            url: TwistApiService.BASE_API_URL + '/donation',
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

  static Future<List<int>> _computeData(String body) async {
    var data = <int>[];
    Map<String, dynamic> jsonData = jsonDecode(body);

    if (jsonData['received'] != null) {
      data.add(jsonData['received'].floor());
      data.add(jsonData['target'].floor());
    }
    return data;
  }
}
