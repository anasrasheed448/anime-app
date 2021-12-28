// Flutter imports:
import 'package:anime_twist_flut/providers.dart';
import 'package:anime_twist_flut/pages/discover_page/DiscoverAnimeTile.dart';
import 'package:anime_twist_flut/pages/discover_page/SubCategoryText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToWatchRow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ToWatchRowState();
  }
}

class _ToWatchRowState extends State<ToWatchRow> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final provider = watch(toWatchProvider);
        if (!provider.hasData()) return Container();
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubCategoryText(
                text: 'To Watch',
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
              ),
              Container(
                height: 300,
                margin: EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    // The list is reversed as the animes are stored from old
                    // to new and we want the user to see the latest added
                    // anime first
                    var recentlyWatchedModel =
                        provider.toWatchAnimes.reversed.elementAt(index);
                    return Container(
                      width: 200,
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: DiscoverAnimeTile(
                        twistModel: recentlyWatchedModel.twistModel,
                        kitsuModel: recentlyWatchedModel.kitsuModel,
                      ),
                    );
                  },
                  itemCount: provider.toWatchAnimes.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
