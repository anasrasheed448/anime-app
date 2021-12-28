import 'dart:ui';

import 'package:anime_twist_flut/animations/Transitions.dart';
import 'package:anime_twist_flut/constants.dart';
import 'package:anime_twist_flut/models/TwistModel.dart';
import 'package:anime_twist_flut/models/kitsu/KitsuModel.dart';
import 'package:anime_twist_flut/pages/anime_info_page/AnimeInfoPage.dart';
import 'package:anime_twist_flut/widgets/custom_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DiscoverAnimeTile extends StatelessWidget {
  const DiscoverAnimeTile({
    Key key,
    this.twistModel,
    this.kitsuModel,
  }) : super(key: key);

  final TwistModel twistModel;
  final KitsuModel kitsuModel;

  String getImageUrl(BuildContext context) {
    return kitsuModel.posterImage ?? kitsuModel.coverImage ?? DEFAULT_IMAGE_URL;
  }

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).cardColor;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Column(
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: color,
                      ),
                    ),
                    Positioned.fill(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: getImageUrl(context),
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => CustomShimmer(),
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: color,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    twistModel.title.toUpperCase(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Transitions.slideTransition(
                    context: context,
                    pageBuilder: () => AnimeInfoPage(
                      twistModel: twistModel,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
