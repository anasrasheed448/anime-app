// Package imports:
import 'package:anime_twist_flut/services/kitsu_service/KitsuApiService.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:

void main() {
  test('Kitsu API service test', () async {
    var kitsuModel = await KitsuApiService.getKitsuModel(43124, false);
    expect(kitsuModel.trailerURL, 'rU6HjgMIIBs');
  });
}
