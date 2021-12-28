import 'package:anime_twist_flut/animations/Transitions.dart';
import 'package:anime_twist_flut/models/TwistModel.dart';
import 'package:anime_twist_flut/models/kitsu/KitsuModel.dart';
import 'package:anime_twist_flut/pages/anime_info_page/AnimeInfoPage.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class DiscoverAnimeCard extends StatelessWidget {
  const DiscoverAnimeCard({
    Key key,
    @required this.kitsuModel,
    @required this.twistModel,
  }) : super(key: key);

  final KitsuModel kitsuModel;
  final TwistModel twistModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    kitsuModel.posterImage,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      if (frame != null) return child;
                      return Image.asset('assets/discover_placeholder.png');
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Image.asset('assets/discover_placeholder.png');
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          twistModel.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: AutoSizeText(
                              kitsuModel.description,
                              overflow: TextOverflow.fade,
                              maxLines: 20,
                              minFontSize: 15,
                              maxFontSize: 20,
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Transitions.slideTransition(
                  context: context,
                  pageBuilder: () => AnimeInfoPage(
                    twistModel: twistModel,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
