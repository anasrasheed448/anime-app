import 'package:anime_twist_flut/providers/KitsuDiscoverURLProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SeasonSelector extends StatelessWidget {
  const SeasonSelector({
    Key key,
    @required this.searchLinkProvder,
  }) : super(key: key);

  final ChangeNotifierProvider<KitsuDiscoverURLProvider> searchLinkProvder;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        var prov = watch(searchLinkProvder);
        return Card(
          child: InkWell(
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (context) {
                return SingleChildScrollView(
                  child: Column(
                    children: KitsuSeason.values
                        .map(
                          (e) => ListTile(
                            trailing: e == prov.kitsuSeason
                                ? Icon(
                                    Icons.check,
                                    color: Theme.of(context).accentColor,
                                  )
                                : null,
                            title: Text(
                              prov.parseSeason(e),
                              style: TextStyle(
                                fontWeight: e == prov.kitsuSeason
                                    ? FontWeight.bold
                                    : null,
                                color: e == prov.kitsuSeason
                                    ? Theme.of(context).accentColor
                                    : null,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              prov.kitsuSeason = e;
                            },
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Season: ' + prov.parseSeason(prov.kitsuSeason),
              ),
            ),
          ),
        );
      },
    );
  }
}
