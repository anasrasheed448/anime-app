// Flutter imports:
import 'package:anime_twist_flut/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:anime_twist_flut/utils/GetUtils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../../animations/Transitions.dart';
import '../../../models/EpisodeModel.dart';
import '../../../models/kitsu/KitsuModel.dart';
import '../../../models/TwistModel.dart';
import '../../../providers/EpisodesWatchedProvider.dart';
import '../../watch_page/WatchPage.dart';
import '../../../utils/GetUtils.dart';

class EpisodeCard extends StatelessWidget {
  final List<EpisodeModel> episodes;
  final EpisodeModel episodeModel;

  final TwistModel twistModel = Get.find();
  final KitsuModel kitsuModel = Get.find<KitsuModel>();
  final ChangeNotifierProvider<EpisodesWatchedProvider> episodesWatchedProvider;

  EpisodeCard({
    @required this.episodes,
    @required this.episodeModel,
    @required this.episodesWatchedProvider,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var orientation = MediaQuery.of(context).orientation;

    return Consumer(
      builder: (context, watch, child) {
        final prov = watch(episodesWatchedProvider);
        return CupertinoContextMenu(
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: 20.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
                elevation: 0,
                primary: Theme.of(context).dialogBackgroundColor,
              ),
              onPressed: () {
                prov.toggleWatched(episodeModel.number);
                Navigator.of(context).pop();
              },
              child: Text(prov.isWatched(episodeModel.number)
                  ? 'Remove from watched'
                  : 'Add to watched'),
            ),
            SizedBox(
              height: 5.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: 20.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
                elevation: 0,
                primary: Theme.of(context).dialogBackgroundColor,
              ),
              onPressed: () {
                prov.setWatchedTill(episodeModel.number);
                Navigator.of(context).pop();
              },
              child: Text('Set watched till here'),
            ),
          ],
          child: Container(
            width: width * 0.5,
            height: orientation == Orientation.portrait
                ? height * 0.07
                : height * 0.175,
            child: Card(
              child: InkWell(
                onTap: () {
                  context.read(recentlyWatchedProvider).addToLastWatched(
                        twistModel: twistModel,
                        kitsuModel: kitsuModel,
                        episodeModel: episodeModel,
                      );
                  Transitions.slideTransition(
                    context: context,
                    pageBuilder: () => WatchPage(
                      episodeModel: episodeModel,
                      episodes: episodes,
                      episodesWatchedProvider: episodesWatchedProvider,
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        'EP ' + episodeModel.number.toString(),
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Theme.of(context)
                              .textTheme
                              .headline6
                              .color
                              .withOpacity(
                                0.9,
                              ),
                        ),
                      ),
                      prov.isWatched(episodeModel.number)
                          ? Icon(
                              Icons.check,
                              color: Theme.of(context).accentColor,
                            )
                          : Icon(
                              Icons.navigate_next,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
