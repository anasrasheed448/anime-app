// Package imports:
import 'package:edit_distance/edit_distance.dart';

// Project imports:
import '../../models/TwistModel.dart';

// Project imports:

class SearchUtils {
  static bool isTextInAnimeModel({String text, TwistModel twistModel}) {
    var _text = text.toLowerCase();
    var _title = twistModel.title.toLowerCase();
    var _altTitle = twistModel.altTitle?.toLowerCase() ?? _title;

    var jw = JaroWinkler();
    if (_text.isEmpty ||
        _title.contains(_text) ||
        _altTitle.contains(_text) ||
        jw.normalizedDistance(_title, _text) < 0.3 ||
        jw.normalizedDistance(_altTitle, _text) < 0.3) return true;
    return false;
  }
}

extension StringExtensions on String {
  String removeWhitespace() {
    return replaceAll(' ', '');
  }
}
