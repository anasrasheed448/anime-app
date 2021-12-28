import 'package:anime_twist_flut/models/TwistModel.dart';
import 'package:anime_twist_flut/models/kitsu/KitsuAnimeListModel.dart';
import 'package:anime_twist_flut/models/kitsu/KitsuModel.dart';
import 'package:anime_twist_flut/pages/discover_page/CategorySelecter.dart';
import 'package:anime_twist_flut/pages/discover_page/DiscoverAnimeCard.dart';
import 'package:anime_twist_flut/pages/discover_page/SeasonSelecter.dart';
import 'package:anime_twist_flut/pages/discover_page/StatusSelector.dart';
import 'package:anime_twist_flut/pages/discover_page/SubtypeSelecter.dart';
import 'package:anime_twist_flut/providers/KitsuDiscoverURLProvider.dart';
import 'package:anime_twist_flut/services/kitsu_service/KitsuAnimeListApiService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

class DiscoverPage extends StatefulWidget {
  DiscoverPage({Key key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with AutomaticKeepAliveClientMixin {
  KitsuAnimeListModel kitsuAnimeListModel;
  Map<TwistModel, KitsuModel> dataModels;
  ScrollController scrollController;
  FutureProvider _futureProvider;
  TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          kitsuAnimeListModel != null &&
          kitsuAnimeListModel.links.next != null) {
        getData(context.read(searchLinkProvder));
      }
    });

    textEditingController = TextEditingController();

    context.read(searchLinkProvder).addListener(() {
      dataModels.clear();
      kitsuAnimeListModel = null;
      context.refresh(_futureProvider);
    });

    _futureProvider = FutureProvider((ref) async {
      await getData(ref.read(searchLinkProvder));
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  final searchLinkProvder =
      ChangeNotifierProvider<KitsuDiscoverURLProvider>((ref) {
    return KitsuDiscoverURLProvider();
  });

  Future<Tuple2<Map<TwistModel, KitsuModel>, KitsuAnimeListModel>> getData(
      KitsuDiscoverURLProvider discoverURLProvider) async {
    var data =
        Tuple2<Map<TwistModel, KitsuModel>, KitsuAnimeListModel>(null, null);
    if (kitsuAnimeListModel != null) {
      data = await KitsuAnimeListApiService(
        url: kitsuAnimeListModel.links.next ??
            discoverURLProvider.constructURL(),
        cacheKey: kitsuAnimeListModel.links.next ??
            discoverURLProvider.constructURL(),
        shouldCache: false,
      ).getData();
    } else {
      data = await KitsuAnimeListApiService(
        url: discoverURLProvider.constructURL(),
        cacheKey: discoverURLProvider.constructURL(),
        shouldCache: false,
      ).getData();
    }
    setState(() {
      kitsuAnimeListModel = data.item2;
      if (dataModels != null) {
        dataModels.addAll(data.item1);
      } else {
        dataModels = data.item1;
      }
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Column(
      children: [
        Consumer(
          builder: (context, watch, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 16.0,
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      SubtypeSelecter(searchLinkProvder: searchLinkProvder),
                      CategorySelecter(searchLinkProvder: searchLinkProvder),
                      StatusSelector(searchLinkProvder: searchLinkProvder),
                      SeasonSelector(searchLinkProvder: searchLinkProvder)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 5.0,
                  ),
                  child: TextField(
                    controller: textEditingController,
                    cursorColor: Theme.of(context).accentColor,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).accentColor, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      ),
                    ),
                    onChanged: (text) =>
                        context.read(searchLinkProvder).searchQuery = text,
                  ),
                ),
              ],
            );
          },
        ),
        Expanded(
          child: Consumer(
            builder: (context, watch, child) {
              return watch(_futureProvider).when(
                data: (_) {
                  return Scrollbar(
                    controller: scrollController,
                    child: CustomScrollView(
                      physics: BouncingScrollPhysics(),
                      controller: scrollController,
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            top: 5.0,
                          ),
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isPortrait ? 1 : 2,
                              crossAxisSpacing: 6,
                              mainAxisSpacing: 10,
                              childAspectRatio: isPortrait ? 2 : 2.25,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return DiscoverAnimeCard(
                                  twistModel: dataModels.keys.elementAt(index),
                                  kitsuModel:
                                      dataModels.values.elementAt(index),
                                );
                              },
                              childCount: dataModels.length,
                            ),
                          ),
                        ),
                        if (kitsuAnimeListModel != null &&
                            kitsuAnimeListModel.links.next != null)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                        SliverPadding(padding: EdgeInsets.only(bottom: 8.0)),
                      ],
                    ),
                  );
                },
                loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
                error: (e, s) => Container(),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
