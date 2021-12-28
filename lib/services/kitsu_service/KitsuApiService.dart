import 'package:anime_twist_flut/models/TwistModel.dart';
import 'package:anime_twist_flut/models/kitsu/KitsuAnimeListModel.dart';
import 'package:anime_twist_flut/models/kitsu/KitsuModel.dart';
import 'package:anime_twist_flut/services/kitsu_service/KitsuAnimeListApiService.dart';
import 'package:anime_twist_flut/services/kitsu_service/KitsuModelApiService.dart';
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import 'package:tuple/tuple.dart';

class KitsuApiService {
  static Future<KitsuModel> getKitsuModel(int kitsuID, bool ongoing) async {
    return KitsuModelApiService.getKitsuModel(kitsuID, ongoing);
  }

  static Future<Tuple2<Map<TwistModel, KitsuModel>, KitsuAnimeListModel>>
      getAllTimePopularAnimes() async {
    var allTimePopService = KitsuAnimeListApiService(
      url: 'https://www.kitsu.io/api/edge/anime?sort=-averageRating',
      cacheKey: 'allTimePopular',
      shouldCache: true,
    );
    return allTimePopService.getData();
  }

  static Future<Tuple2<Map<TwistModel, KitsuModel>, KitsuAnimeListModel>>
      getAiringPopular() async {
    var airingPopularService = KitsuAnimeListApiService(
      url:
          'https://www.kitsu.io/api/edge/anime?sort=-averageRating&filter[status]=current',
      cacheKey: 'airingPopular',
      shouldCache: true,
    );
    return airingPopularService.getData();
  }
  static Future<Tuple2<Map<TwistModel, KitsuModel>, KitsuAnimeListModel>>
  getHashtags() async {
    var HashtagsService = KitsuAnimeListApiService(
      url:
      'https://www.kitsu.io/api/edge/anime?sort=-averageRating&filter[status]=current',
      cacheKey: 'airingPopular',
      shouldCache: true,
    );
    return HashtagsService.getData();
  }

  static Future<Tuple2<Map<TwistModel, KitsuModel>, KitsuAnimeListModel>>
      getFanFavourites() async {
    var airingPopularService = KitsuAnimeListApiService(
      url: 'https://www.kitsu.io/api/edge/anime?sort=-favoritesCount',
      cacheKey: 'fanFavourites',
      shouldCache: true,
    );
    return airingPopularService.getData();
  }

  static Future<Tuple2<Map<TwistModel, KitsuModel>, KitsuAnimeListModel>>
      getTopMovies() async {
    var topMoviesService = KitsuAnimeListApiService(
      url:
          'https://www.kitsu.io/api/edge/anime?filter[subtype]=movie&sort=-averageRating&page[limit]=20',
      cacheKey: 'topMovies',
      shouldCache: true,
    );
    return topMoviesService.getData();
  }

  static TwistModel getTwistModel(String kitsuId) {
    if (TwistApiService.allKitsuIds.contains(kitsuId)) {
      return TwistApiService.allTwistModel
          .elementAt(TwistApiService.allKitsuIds.indexOf(kitsuId));
    }
    return null;
  }
}
