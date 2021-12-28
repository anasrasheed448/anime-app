import 'package:anime_twist_flut/animations/Transitions.dart';
import 'package:anime_twist_flut/pages/chat_page/ChatPage.dart';
import 'package:anime_twist_flut/pages/homepage/AppbarText.dart';
import 'package:anime_twist_flut/pages/search_page/SearchPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RootWindowLandscape extends StatelessWidget {
  const RootWindowLandscape({
    Key key,
    @required this.indexProvider,
    @required this.pages,
    @required this.pageController,
    @required this.pageViewKey,
  }) : super(key: key);

  final StateProvider indexProvider;
  final List<Widget> pages;
  final PageController pageController;
  final GlobalKey pageViewKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        primary: true,
        title: AppbarText(),
        actions: [
          IconButton(
            icon: Icon(
              Icons.chat_bubble,
            ),
            onPressed: () {
              Transitions.slideTransition(
                context: context,
                pageBuilder: () => ChatPage(),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: () {
              Transitions.slideTransition(
                context: context,
                pageBuilder: () => SearchPage(),
              );
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, watch, child) {
          var prov = watch(indexProvider);
          return Row(
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.dark(
                    primary: Theme.of(context).accentColor,
                  ),
                ),
                child: NavigationRail(
                  onDestinationSelected: (index) {
                    pageController.jumpToPage(index);
                    return prov.state = index;
                  },
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  selectedIconTheme: IconThemeData(
                    color: Theme.of(context).accentColor,
                  ),
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite_outline),
                      selectedIcon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.grid_view),
                      selectedIcon: Icon(Icons.grid_view),
                      label: Text('Discover'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings_outlined),
                      selectedIcon: Icon(Icons.settings),
                      label: Text('Settings'),
                    ),
                  ],
                  selectedIndex: prov.state,
                ),
              ),
              VerticalDivider(
                thickness: 1,
                width: 1,
                indent: 0.0,
                endIndent: 0.0,
              ),
              Expanded(
                child: PageView(
                  key: pageViewKey,
                  controller: pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: pages,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
