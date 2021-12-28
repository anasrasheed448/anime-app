// Flutter imports:
import 'package:anime_twist_flut/models/RecentlyWatchedModel.dart';
import 'package:anime_twist_flut/models/kitsu/RatingFrequency.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import '../models/EpisodeModel.dart';
import '../models/kitsu/KitsuModel.dart';
import '../models/TwistModel.dart';

class RecentlyWatchedProvider extends ChangeNotifier {
  List<RecentlyWatchedModel> recentlyWatchedAnimes = [];
  static const int MAX_LEN = 5;
  static const String BOX_NAME = 'lastWatched';
  static const String KEY_NAME = 'list';

  Future initialize() async {
    try {
      await Hive.initFlutter((await getApplicationDocumentsDirectory()).path);
      Hive.registerAdapter<TwistModel>(TwistModelAdapter());
      Hive.registerAdapter<RatingFrequencies>(RatingFrequenciesAdapter());
      Hive.registerAdapter<KitsuModel>(KitsuModelAdapter());
      Hive.registerAdapter<EpisodeModel>(EpisodeModelAdapter());
      Hive.registerAdapter<RecentlyWatchedModel>(RecentlyWatchedModelAdapter());
      var box = await Hive.openBox(BOX_NAME);

      // For whatever reason, directly assigning lastWatchedAnimes to
      // box.get(KEY_NAME) does not work, so loop through all the elements and add
      // it to the list one by one.
      dynamic contents = box?.get(KEY_NAME) ?? [];
      for (var i = 0; i < contents?.length ?? 0; i++) {
        recentlyWatchedAnimes.add(contents[i]);
      }
    } catch (e) {
      throw Exception('Cannot load recently watched animes\n' + e.toString());
    }
  }

  void addToLastWatched({
    TwistModel twistModel,
    KitsuModel kitsuModel,
    EpisodeModel episodeModel,
  }) {
    var lastWatchedModel = RecentlyWatchedModel(
      twistModel,
      kitsuModel,
      episodeModel,
    );
    recentlyWatchedAnimes ??= [];

    // If lastWatchedAnimes already contains the anime we are trying to add,
    // then remove that anime from the list and proceed.
    var index = isAlreadyInWatching(lastWatchedModel);
    if (index != -1) {
      recentlyWatchedAnimes.removeAt(index);
    }

    // If lastWatchedAnimes has more than MAX_LEN anime, then remove the oldest
    // anime (at index 0) and add the anime we are trying to add by
    // making a new list and making it the last element. Else add anime to
    // lastWatchedModel
    if (recentlyWatchedAnimes.length >= MAX_LEN) {
      recentlyWatchedAnimes.removeAt(0);
      recentlyWatchedAnimes.add(lastWatchedModel);
    } else {
      recentlyWatchedAnimes.add(lastWatchedModel);
    }
    writeToBox();
  }

  /// Checks if [recentlyWatchedAnimes] contains [lastWatchedModel] and returns its
  /// index, else returns -1
  int isAlreadyInWatching(RecentlyWatchedModel lastWatchedModel) {
    var index = -1;
    for (var i = 0; i < recentlyWatchedAnimes.length; i++) {
      index++;
      if (recentlyWatchedAnimes[i].twistModel == lastWatchedModel.twistModel) {
        return index;
      }
    }
    return -1;
  }

  void writeToBox() {
    var box = Hive.box(BOX_NAME);

    // Write to the box and notifyListeners that data has been updated
    box.put(KEY_NAME, recentlyWatchedAnimes);
    notifyListeners();
  }

  void clearData() {
    recentlyWatchedAnimes.clear();
    writeToBox();
  }

  bool hasData() {
    return recentlyWatchedAnimes != null && recentlyWatchedAnimes.isNotEmpty;
  }
}
