import 'package:anime_twist_flut/models/FavouritedModel.dart';
import 'package:anime_twist_flut/models/kitsu/KitsuModel.dart';
import 'package:anime_twist_flut/models/TwistModel.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class FavouriteAnimeProvider extends ChangeNotifier {
  static const String BOX_NAME = 'favouritedAnime';
  static const String KEY = '1';

  List<FavouritedModel> favouritedAnimes = [];

  Future initialize() async {
    try {
      Hive.registerAdapter<FavouritedModel>(FavouritedModelAdapter());
      var box = await Hive.openBox(BOX_NAME);
      dynamic contents = box?.get(KEY) ?? [];

      for (var i = 0; i < contents?.length ?? 0; i++) {
        favouritedAnimes.add(contents[i]);
      }
    } catch (e) {
      throw Exception('Cannot load to watch animes');
    }
    notifyListeners();
  }

  Future _writeData() async {
    var box = Hive.box(BOX_NAME);
    await box.put(KEY, favouritedAnimes);
    notifyListeners();
  }

  bool isFavourite(String slug) {
    for (var item in favouritedAnimes) {
      if (item.slug == slug) {
        return true;
      }
    }
    return false;
  }

  void addToFavourites(TwistModel twistModel, KitsuModel kitsuModel) {
    favouritedAnimes.add(
      FavouritedModel(
        slug: twistModel.slug,
        coverURL: kitsuModel?.coverImage,
        posterURL: kitsuModel?.posterImage,
      ),
    );
    _writeData();
  }

  void removeFromFavourites(String slug) {
    for (var item in favouritedAnimes) {
      if (item.slug == slug) {
        favouritedAnimes.remove(item);
        break;
      }
    }

    _writeData();
  }

  void clearFavourites() {
    favouritedAnimes.clear();
    _writeData();
  }

  void toggleFromFavourites(TwistModel twistModel, KitsuModel kitsuModel) {
    if (isFavourite(twistModel.slug)) {
      removeFromFavourites(twistModel.slug);
    } else {
      addToFavourites(twistModel, kitsuModel);
    }
  }

  /// Whether we have any favourites.
  bool hasData() {
    return favouritedAnimes.isNotEmpty;
  }
}
