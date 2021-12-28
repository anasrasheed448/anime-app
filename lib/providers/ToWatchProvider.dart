import 'package:anime_twist_flut/models/RecentlyWatchedModel.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hive/hive.dart';

// Project imports:
import '../models/EpisodeModel.dart';
import '../models/kitsu/KitsuModel.dart';
import '../models/TwistModel.dart';
import 'RecentlyWatchedProvider.dart';

/// This class is a copy of [RecentlyWatchedProvider]
/// It uses [RecentlyWatchedModel] since it basically stores the same data as we
/// want to be saved.
class ToWatchProvider extends ChangeNotifier {
  List<RecentlyWatchedModel> toWatchAnimes = [];
  static const String BOX_NAME = 'toWatch';
  static const String KEY_NAME = 'list';

  Future initialize() async {
    try {
      var box = await Hive.openBox(BOX_NAME);
      // For whatever reason, directly assigning toWatchAnimes to
      // box.get(KEY_NAME) does not work, so loop through all the elements and
      // add it to the list one by one.
      dynamic contents = box?.get(KEY_NAME) ?? [];
      for (var i = 0; i < contents?.length ?? 0; i++) {
        toWatchAnimes.add(contents[i]);
      }
    } catch (e) {
      throw Exception('Cannot load to watch animes');
    }
  }

  void toggleFromToWatched({
    TwistModel twistModel,
    KitsuModel kitsuModel,
    EpisodeModel episodeModel,
  }) {
    var lastWatchedModel = RecentlyWatchedModel(
      twistModel,
      kitsuModel,
      episodeModel,
    );
    toWatchAnimes ??= [];

    // Checks if lastWatchedModel is already in toWatchAnimes, deletes if its
    // present and adds if its not
    var index = isAlreadyInToWatch(lastWatchedModel.twistModel);
    if (index != -1) {
      toWatchAnimes.removeAt(index);
    } else {
      toWatchAnimes.add(lastWatchedModel);
    }

    writeToBox();
  }

  /// Checks if [toWatchAnimes] contains [twistModel] and returns its
  /// index, else returns -1
  int isAlreadyInToWatch(TwistModel twistModel) {
    var index = -1;
    for (var i = 0; i < toWatchAnimes.length; i++) {
      index++;
      if (toWatchAnimes[i].twistModel == twistModel) {
        return index;
      }
    }
    return -1;
  }

  void writeToBox() {
    var box = Hive.box(BOX_NAME);

    // Write to the box and notifyListeners that data has been updated
    box.put(KEY_NAME, toWatchAnimes);
    notifyListeners();
  }

  void clearData() {
    toWatchAnimes.clear();
    writeToBox();
  }

  bool hasData() {
    return toWatchAnimes != null && toWatchAnimes.isNotEmpty;
  }
}
