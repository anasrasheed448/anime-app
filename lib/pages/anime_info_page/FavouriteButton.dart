import 'package:anime_twist_flut/providers.dart';
import 'package:anime_twist_flut/models/kitsu/KitsuModel.dart';
import 'package:anime_twist_flut/models/TwistModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavouriteButton extends StatelessWidget {
  const FavouriteButton(
      {Key key, @required this.twistModel, @required this.kitsuModel})
      : super(key: key);

  final KitsuModel kitsuModel;
  final TwistModel twistModel;

  @override
  Widget build(BuildContext context) {
    var accentColor = Theme.of(context).accentColor;
    var side = 55;

    return Container(
      margin: EdgeInsets.only(
        right: 16.0,
        top: 25.0,
        bottom: 20.0,
      ),
      height: side.toDouble(),
      width: side.toDouble(),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(
          8.0,
        ),
      ),
      child: Consumer(
        builder: (context, watch, child) {
          var prov = watch(favouriteAnimeProvider);
          var isFav = prov.isFavourite(twistModel.slug);

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => prov.toggleFromFavourites(
                twistModel,
                kitsuModel,
              ),
              borderRadius: BorderRadius.circular(
                8.0,
              ),
              child: Icon(
                isFav ? Icons.favorite : Icons.favorite_outline,
                color: accentColor.computeLuminance() < 0.5
                    ? Colors.white
                    : Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
