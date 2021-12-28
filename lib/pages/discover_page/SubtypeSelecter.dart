import 'package:anime_twist_flut/providers/KitsuDiscoverURLProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubtypeSelecter extends StatelessWidget {
  const SubtypeSelecter({
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
                    children: KitsuSubtype.values
                        .map(
                          (e) => ListTile(
                            trailing: e == prov.kitsuSubtype
                                ? Icon(
                                    Icons.check,
                                    color: Theme.of(context).accentColor,
                                  )
                                : null,
                            title: Text(
                              prov.parseSubtype(e),
                              style: TextStyle(
                                fontWeight: e == prov.kitsuSubtype
                                    ? FontWeight.bold
                                    : null,
                                color: e == prov.kitsuSubtype
                                    ? Theme.of(context).accentColor
                                    : null,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              prov.kitsuSubtype = e;
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
                'Subtype: ' + prov.parseSubtype(prov.kitsuSubtype),
              ),
            ),
          ),
        );
      },
    );
  }
}
