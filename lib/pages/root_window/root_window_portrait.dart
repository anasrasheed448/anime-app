import 'package:anime_twist_flut/animations/Transitions.dart';
import 'package:anime_twist_flut/pages/chat_page/ChatPage.dart';
import 'package:anime_twist_flut/pages/homepage/AppbarText.dart';
import 'package:anime_twist_flut/pages/search_page/SearchPage.dart';
import 'package:anime_twist_flut/pages/discover_page/DiscoverPage.dart';
import 'package:anime_twist_flut/pages/settings_page/SettingsPage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:anime_twist_flut/pages/favourites_page/FavouritesPage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';

class RootWindowPortrait extends StatelessWidget {
  RootWindowPortrait({
    Key key,
    @required this.pages,
    @required this.indexProvider,
    @required this.pageController,
    @required this.pageViewKey,
  }) : super(key: key);

  final List<Widget> pages;
  final StateProvider indexProvider;
  final PageController pageController;
  final GlobalKey pageViewKey;

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //  DeviceOrientation.portraitUp,
    //  DeviceOrientation.portraitDown,
    //]);
    return Consumer(
      builder: (context, watch, child) {
        var prov = watch(indexProvider);
        return Scaffold(
          appBar: AppBar(
            primary: true,
            title: AppbarText(),
            actions: [
              IconButton(
                color: Colors.white30,
                icon: Icon(
                  Icons.favorite,
                ),
                onPressed: () async {
                  await toggleAd();
                  await Transitions.slideTransition(
                    context: context,
                    pageBuilder: () => FavouritesPage(),
                  );
                },
              ),
              IconButton(
                color: Colors.white30,
                icon: Icon(
                  Icons.search,
                ),
                onPressed: () async {
                  await toggleAd();
                  await Transitions.slideTransition(
                    context: context,
                    pageBuilder: () => SearchPage(),
                  );
                },
              ),
              IconButton(
                color: Colors.white30,
                icon: Icon(
                  Icons.settings,
                ),
                onPressed: () {
                  Transitions.slideTransition(
                    context: context,
                    pageBuilder: () => SettingsPage(),
                  );
                },
              ),
            ],
          ),
          /*
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: prov.state,
            onTap: (index) {
              pageController.jumpToPage(index);
              return prov.state = index;
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                tooltip: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline),
                label: 'Favorites',
                tooltip: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_view),
                label: 'Discover',
                tooltip: 'Discover',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
                tooltip: 'Settings',
              ),
            ],
          ),*/
          // body: pages.elementAt(prov.state),
          body: PageView(
            key: pageViewKey,
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            children: pages,
          ),
        );
      },
    );
  }
}
