// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';

void main() {
  group('Twist API Service Tests\n', () {
    var twistApiService = TwistApiService();

    test('Anime API service test\n', () async {
      SharedPreferences.setMockInitialValues({
        'anime_cache': [null, null]
      });

      await twistApiService.setTwistModels();
      expect(TwistApiService.allTwistModel.isNotEmpty, true);
      expect(TwistApiService.allTwistModel[0].runtimeType.toString(),
          'TwistModel');
      expect(TwistApiService.allTwistModel[0].slug, '07-ghost');
    });

    test('Donation API service test\n', () async {
      var data = await twistApiService.getDonationsData();
      expect(data[0].runtimeType, int);
      expect(data[1].runtimeType, int);

      expect(data[0] >= 0, true);
      expect(data[1] >= 0, true);
    });

    test('MOTD API service test\n', () async {
      var data = await twistApiService.getMOTD();
      expect(data[0].runtimeType, String);
      expect(data[1].runtimeType, String);

      expect(data[0].isNotEmpty, true);
      expect(data[1].isNotEmpty, true);
    });

    test('Episode API service test\n', () async {
      var data = await twistApiService.getEpisodesForSource(
        twistModel: TwistApiService.allTwistModel.first,
      );
      expect(data.isNotEmpty, true);
      expect(data.first.source.isNotEmpty, true);
      expect(data.first.source.runtimeType, String);
    });
  });
}
