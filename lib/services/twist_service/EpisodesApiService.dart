// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:anime_twist_flut/exceptions/TwistDownException.dart';
import 'package:anime_twist_flut/services/CacheService.dart';
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import 'package:anime_twist_flut/utils/JsonUtils.dart';
import 'package:flutter/foundation.dart';
import 'package:supercharged_dart/supercharged_dart.dart';

import '../../cached_http_get/CachedHttpGet.dart';
import '../../models/EpisodeModel.dart';
import '../../models/TwistModel.dart';
import '../../secrets.dart';

class EpisodeApiService {
  static Future<List<EpisodeModel>> getEpisodes(TwistModel twistModel) async {
    var cacheService = CacheService(
      '/anime/episodes/${twistModel.slug}',
      7.days,
    );

    await cacheService.initialize(false);

    var response = await cacheService.getDataAndCacheIfNeeded(
      getData: () async {
        return await CachedHttpGet.get(
          Request(
            url: '${TwistApiService.BASE_API_URL}/anime/' +
                twistModel.slug.toString() +
                '/sources',
            header: {
              'x-access-token': x_access_token,
            },
          ),
          TwistDownException(),
        );
      },
      onCache: () {},
      onSkipCache: () {},
      willUpdateCache: (cachedData, __) async {
        if (twistModel.ongoing) return true;
        return !JsonUtils.isValidJson(cachedData);
      },
    );
    return await compute(_computeData, response);
  }

  static Future<List<EpisodeModel>> _computeData(String data) async {
    var ret = <EpisodeModel>[];
    List<dynamic> jsonData = jsonDecode(data);

    jsonData.forEach(
      (element) {
        ret.add(
          EpisodeModel.fromJson(element),
        );
      },
    );

    return ret;
  }
}
