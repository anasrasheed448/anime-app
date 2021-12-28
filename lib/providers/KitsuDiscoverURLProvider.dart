import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class KitsuDiscoverURLProvider extends ChangeNotifier {
  static const base =
      'https://kitsu.io/api/edge/anime?page[limit]=20&sort=-userCount';

  static const baseUnsorted = 'https://kitsu.io/api/edge/anime?page[limit]=20';

  KitsuCategory _kitsuCategory = KitsuCategory.All;
  KitsuSubtype _kitsuSubtype = KitsuSubtype.All;
  KitsuStatus _kitsuStatus = KitsuStatus.All;
  KitsuSeason _kitsuSeason = KitsuSeason.All;
  String _searchQuery = '';
  String URL = '';

  KitsuSeason get kitsuSeason => _kitsuSeason;

  set kitsuSeason(KitsuSeason season) {
    _kitsuSeason = season;
    URL = constructURL();
    notifyListeners();
  }

  KitsuStatus get kitsuStatus => _kitsuStatus;

  set kitsuStatus(KitsuStatus status) {
    _kitsuStatus = status;
    URL = constructURL();
    notifyListeners();
  }

  String get searchQuery => _searchQuery;

  set searchQuery(String query) {
    _searchQuery = query;
    URL = constructURL();
    notifyListeners();
  }

  KitsuCategory get kitsuCategory => _kitsuCategory;

  set kitsuCategory(KitsuCategory category) {
    _kitsuCategory = category;
    URL = constructURL();
    notifyListeners();
  }

  KitsuSubtype get kitsuSubtype => _kitsuSubtype;

  set kitsuSubtype(KitsuSubtype subtype) {
    _kitsuSubtype = subtype;
    URL = constructURL();
    notifyListeners();
  }

  String parseCategory(KitsuCategory category) {
    var categoryString = category.toString().substring(14);
    if (categoryString.contains('_')) {
      categoryString = categoryString.replaceAll('_', ' ');
    }
    return categoryString;
  }

  String parseSubtype(KitsuSubtype subtype) {
    var subtypeString = subtype.toString().substring(13);
    if (subtypeString.contains('_')) {
      subtypeString = subtypeString.replaceAll('_', ' ');
    }
    return subtypeString;
  }

  String parseStatus(KitsuStatus status) {
    var statusString = status.toString().substring(12);
    if (statusString.contains('_')) {
      statusString = statusString.replaceAll('_', ' ');
    }
    return statusString;
  }

  String parseSeason(KitsuSeason season) {
    var seasonString = season.toString().substring(12);
    if (seasonString.contains('_')) {
      seasonString = seasonString.replaceAll('_', ' ');
    }
    return seasonString;
  }

  String constructURL() {
    var ret = base;
    if (_searchQuery.isNotEmpty) {
      ret = baseUnsorted;
      ret += '&filter[text]=$_searchQuery';
    }
    if (_kitsuCategory != KitsuCategory.All) {
      ret += '&filter[categories]=${parseCategory(_kitsuCategory)}';
    }
    if (_kitsuSubtype != KitsuSubtype.All) {
      ret += '&filter[subtype]=${parseSubtype(_kitsuSubtype)}';
    }
    if (_kitsuStatus != KitsuStatus.All) {
      ret += '&filter[status]=${parseStatus(_kitsuStatus)}';
    }
    if (_kitsuSeason != KitsuSeason.All) {
      ret += '&filter[season]=${parseSeason(_kitsuSeason)}';
    }
    print(ret);
    return ret;
  }
}

enum KitsuSubtype {
  All,
  ONA,
  OVA,
  TV,
  Movie,
  Special,
}

enum KitsuCategory {
  All,
  Comedy,
  Fantasy,
  Romance,
  Action,
  School_Life,
  Drama,
  Adventure,
  Slice_of_Life,
  Shoujo_Ai,
  Science_Fiction,
  Yaoi,
  Ecchi,
  Sports,
  Historical,
  Japan,
  Earth,
  Harem,
  Thriller,
  Mystery,
  Magic,
  Present,
  Music,
  Asia,
  Kids,
  Horror,
  Mecha,
  Psychological,
  Martial_Arts,
  Shounen_Ai,
  Super_Power,
  Supernatural,
  Demon,
  Shounen,
  Seinen,
  Military,
  Fantasy_World,
  Violence,
  Plot_Continuity,
  Parody,
  Motorsport,
}

enum KitsuStatus {
  All,
  Current,
  Finished,
}

enum KitsuSeason {
  All,
  Winter,
  Spring,
  Summer,
  Fall,
}
