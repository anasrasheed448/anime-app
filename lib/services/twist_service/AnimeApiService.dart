// Dart imports:
import 'dart:convert';
import 'dart:io';

// Project imports:
import 'package:anime_twist_flut/exceptions/TwistDownException.dart';
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import 'package:anime_twist_flut/utils/JsonUtils.dart';
import 'package:flutter/foundation.dart';

import '../../models/TwistModel.dart';
import '../../secrets.dart';
import '../CacheService.dart';
import 'package:supercharged/supercharged.dart';
import 'package:http/http.dart';

class AnimeApiService {
  static const String baseUrl = 'https://twist.moe/api/anime';

  static Future<List<TwistModel>> getAllTwistModel() async {
    var cacheService = CacheService(
      '/anime',
      7.days,
    );

    await cacheService.initialize();

    var response = await cacheService.getDataAndCacheIfNeeded(
      getData: () async {
        var ret = await get(
          TwistApiService.BASE_API_URL + '/anime',
          headers: {
            'x-access-token': x_access_token,
          },
        );
        if (ret.statusCode != HttpStatus.ok) {
          throw TwistDownException();
        } else {
          return ret.body;
        }
      },
      onCache: () {
        print('Data is not cached or very old');
      },
      onSkipCache: () async {
        print('Data is cached');
        await Future.delayed(Duration(milliseconds: 400));
      },
      willUpdateCache: (cachedData, cachedDateTime) async {
        return !JsonUtils.isValidJson(cachedData);
      },
    );

    if (response == null) {
      throw TwistDownException();
    }

    var ret = <TwistModel>[];
    ret = await compute(_parseAndAdd, response);

    return ret;
  }

  static Future<List<TwistModel>> _parseAndAdd(String data) async {
    var ret = <TwistModel>[];

    List<dynamic> jsonData = jsonDecode(data);

    jsonData.forEach(
      (element) async {
        ret.add(
          TwistModel.fromJson(element),
        );
      },
    );
    return ret;
  }
}
