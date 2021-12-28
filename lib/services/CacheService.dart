import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class CacheService {
  static const String BOX_NAME = 'networkCache';

  final String key;
  final Duration cacheUpdateInterval;

  CacheService(this.key, this.cacheUpdateInterval);

  /// Open the hive box and get ready for reading and writing the cache.
  Future initialize([bool initHive = true]) async {
    if (initHive) {
      await Hive.initFlutter((await getApplicationDocumentsDirectory()).path);
    }
    await Hive.openBox(BOX_NAME);
  }

  static Future<void> clearCache() async {
    var box = await Hive.openBox(BOX_NAME);
    await box.clear();
  }

  /// Caches the given data with [DateTime.now()] so that the time can be
  /// compared later if we want to update.
  Future cache({@required String data}) async {
    var box = Hive.box(BOX_NAME);
    await box.put(key, [DateTime.now().toString(), data]);
  }

  /// Gets the cached data which is stored in index 1 of the list we store.
  Future<String> getCachedData() async {
    var data = await Hive.box(BOX_NAME).get(key);
    if (data == null || data[1] == null) return null;
    return data[1];
  }

  /// Gets the cached [DateTime] which is stored in index 0 of the list we store.
  Future<DateTime> getCachedDateTime() async {
    var data = await Hive.box(BOX_NAME).get(key);
    if (data == null || data[0] == null) return null;
    return DateTime.parse(data[0]);
  }

  Future<bool> shouldUpdateCache(
      {String cachedData,
      DateTime cachedDateTime,
      Future<bool> Function(String data, DateTime dt) willUpdateCache}) async {
    if (cachedData == null) return true;
    if (cachedData.isEmpty) return true;
    if (cachedDateTime == null) return true;
    if (await willUpdateCache(cachedData, cachedDateTime)) return true;
    var now = DateTime.now();
    return now.difference(cachedDateTime).abs() > cacheUpdateInterval;
  }

  Future<String> getDataAndCacheIfNeeded({
    @required Future<String> Function() getData,
    @required Function() onCache,
    @required Function() onSkipCache,
    @required
        Future<bool> Function(String cachedData, DateTime cachedDateTime)
            willUpdateCache,
  }) async {
    var cachedAnimeData = await getCachedData();
    var cachedDate = await getCachedDateTime();
    String ret;

    if (await shouldUpdateCache(
      cachedData: cachedAnimeData,
      cachedDateTime: cachedDate,
      willUpdateCache: willUpdateCache,
    )) {
      ret = await getData();
      await cache(data: ret);
      await onCache();
    } else {
      ret = cachedAnimeData;
      await onSkipCache();
    }
    return ret;
  }
}
