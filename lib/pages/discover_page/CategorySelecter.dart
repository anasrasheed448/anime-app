import 'package:anime_twist_flut/providers/KitsuDiscoverURLProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategorySelecter extends StatelessWidget {
  const CategorySelecter({
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
                return Scrollbar(
                  isAlwaysShown: true,
                  child: ListView(
                    children: KitsuCategory.values
                        .map(
                          (e) => ListTile(
                            trailing: e == prov.kitsuCategory
                                ? Icon(
                                    Icons.check,
                                    color: Theme.of(context).accentColor,
                                  )
                                : null,
                            title: Text(
                              prov.parseCategory(e),
                              style: TextStyle(
                                fontWeight: e == prov.kitsuCategory
                                    ? FontWeight.bold
                                    : null,
                                color: e == prov.kitsuCategory
                                    ? Theme.of(context).accentColor
                                    : null,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              prov.kitsuCategory = e;
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
                'Category: ' + prov.parseCategory(prov.kitsuCategory),
              ),
            ),
          ),
        );
      },
    );
  }
}
