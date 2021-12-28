// Flutter imports:
import 'package:anime_twist_flut/providers/EpisodesWatchedProvider.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:anime_twist_flut/models/EpisodeModel.dart';
import 'package:anime_twist_flut/pages/anime_info_page/episodes/EpisodeCard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EpisodesSliver extends StatelessWidget {
  final List<EpisodeModel> episodes;
  final ChangeNotifierProvider<EpisodesWatchedProvider> episodesWatchedProvider;

  EpisodesSliver({
    Key key,
    @required this.episodes,
    @required this.episodesWatchedProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var isPortrait = orientation == Orientation.portrait;
    var width = MediaQuery.of(context).size.width;

    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 14.0,
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          childAspectRatio: isPortrait ? width / 125 : width / 250,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: EdgeInsets.all(
                1.0,
              ),
              child: EpisodeCard(
                episodeModel: episodes.elementAt(index),
                episodes: episodes,
                episodesWatchedProvider: episodesWatchedProvider,
              ),
            );
          },
          childCount: episodes.length,
        ),
      ),
    );
  }
}
