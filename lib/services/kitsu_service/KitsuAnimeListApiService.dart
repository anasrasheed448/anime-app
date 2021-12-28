import 'dart:convert';

import 'package:anime_twist_flut/cached_http_get/CachedHttpGet.dart';
import 'package:anime_twist_flut/models/TwistModel.dart';
import 'package:anime_twist_flut/models/kitsu/KitsuAnimeListModel.dart';
import 'package:anime_twist_flut/models/kitsu/KitsuModel.dart';
import 'package:anime_twist_flut/services/CacheService.dart';
import 'package:anime_twist_flut/services/kitsu_service/KitsuApiService.dart';
import 'package:anime_twist_flut/utils/JsonUtils.dart';
import 'package:flutter/foundation.dart';
import 'package:supercharged/supercharged.dart';
import 'package:tuple/tuple.dart';

class KitsuAnimeListApiService {
  final String url;
  final String cacheKey;
  final bool shouldCache;

  KitsuAnimeListApiService({
    @required this.url,
    @required this.cacheKey,
    @required this.shouldCache,
  });

  Future<Tuple2<Map<TwistModel, KitsuModel>, KitsuAnimeListModel>>
      getData() async {
    String response;

    if (shouldCache) {
      var cacheService = CacheService(
        '/kitsu/$cacheKey',
        2.days,
      );

      await cacheService.initialize(false);

      response = await cacheService.getDataAndCacheIfNeeded(
        getData: () async {
          return await CachedHttpGet.get(
            Request(
              url: url,
              header: {
                'accept': 'application/vnd.api+json',
                'content-type': 'application/vnd.api+json'
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
    } else {
      response = await CachedHttpGet.get(
        Request(
          url: url,
          header: {
            'accept': 'application/vnd.api+json',
            'content-type': 'application/vnd.api+json'
          },
        ),
      );
    }

    return await _computeData(response);
  }

  Future<Tuple2<Map<TwistModel, KitsuModel>, KitsuAnimeListModel>> _computeData(
      String data) async {
    Map<dynamic, dynamic> jsonData = jsonDecode(data);
    // Check if the kitsu id is invalid.
    // A better solution would be to check for the status code but CachedHttpGet
    // doesnt support this as of now.
    if (jsonData['errors'] != null) return null;

    var kitsuListModel = KitsuAnimeListModel.fromJson(jsonData);
    var ret = Tuple2(<TwistModel, KitsuModel>{}, kitsuListModel);

    for (var item in kitsuListModel.kitsuModels) {
      var twistModel = KitsuApiService.getTwistModel(item.id);
      if (twistModel != null) {
        ret.item1[twistModel] = item;
      }
    }

    return ret;
  }
}
