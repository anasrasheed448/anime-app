// Project imports:
import '../../models/EpisodeModel.dart';
import '../../models/TwistModel.dart';
import 'AnimeApiService.dart';
import 'DonationApiService.dart';
import 'EpisodesApiService.dart';
import 'MOTDApiService.dart';

class TwistApiService {
  static List<TwistModel> allTwistModel = [];
  static List<String> allKitsuIds = [];
  static const String BASE_API_URL = 'https://api.twist.moe/api';

  Future setTwistModels() async {
    allTwistModel = await AnimeApiService.getAllTwistModel();
    allTwistModel.forEach((element) {
      allKitsuIds.add(element.kitsuId.toString());
    });
  }

  Future<List<EpisodeModel>> getEpisodesForSource(
      {TwistModel twistModel}) async {
    return await EpisodeApiService.getEpisodes(twistModel);
  }

  Future<List<String>> getMOTD() async {
    return await MOTDApiService.getMOTD();
  }

  Future<List<int>> getDonationsData() async {
    return await DonationApiService.getDonations();
  }

  TwistModel getTwistModelFromSlug(String slug) {
    for (var i = 0; i < allTwistModel.length; i++) {
      if (allTwistModel.elementAt(i).slug == slug) {
        return allTwistModel.elementAt(i);
      }
    }
    return null;
  }
}
