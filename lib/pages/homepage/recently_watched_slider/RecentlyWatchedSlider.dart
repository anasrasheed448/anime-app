// Flutter imports:
import 'package:anime_twist_flut/providers.dart';
import 'package:anime_twist_flut/pages/homepage/recently_watched_slider/DefaultCard.dart';
import 'package:anime_twist_flut/pages/homepage/recently_watched_slider/RecentlyWatchedText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Project imports:
import 'RecentlyWatchedCard.dart';

class RecentlyWatchedSlider extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RecentlyWatchedSliderState();
  }
}

final offsetProvider = StateProvider<double>((ref) {
  return 0.0;
});

class _RecentlyWatchedSliderState extends State<RecentlyWatchedSlider> {
  PageController _controller;
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    _controller = PageController();
    _controller.addListener(() {
      var offset = _controller.page - _controller.page.floor();
      context.read(offsetProvider).state = offset;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var orientation = MediaQuery.of(context).orientation;
    var topInset = MediaQuery.of(context).viewPadding.top;

    var containerHeight =
        orientation == Orientation.portrait ? height * 0.4 : width * 0.3;
    return Consumer(
      builder: (context, watch, child) {
        final provider = watch(recentlyWatchedProvider);
        if (!provider.hasData()) return DefaultCard();
        return Stack(
          children: [
            Container(
              height: containerHeight + topInset,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    controller: _controller,
                    itemBuilder: (context, index) {
                      // Since the lastWatchedAnimes are stored from oldest first to
                      // newest last, reverse the list so that the latest watched
                      // anime is shown first. Maybe do this in the service itself
                      // but fine here for now.
                      var lastWatchedAnimes =
                          provider.recentlyWatchedAnimes.reversed.toList();

                      return RecentlyWatchedCard(
                        lastWatchedModel: lastWatchedAnimes[index],
                        pageNum: index,
                        pageController: _controller,
                      );
                    },
                    onPageChanged: (index) {
                      setState(() {
                        _currentPageNotifier.value = index;
                      });
                    },
                    itemCount: provider.recentlyWatchedAnimes.length,
                  ),
                  Positioned(
                    bottom: (orientation == Orientation.portrait
                            ? height * 0.3
                            : width * 0.23) +
                        topInset / 2,
                    child: RecentlyWatchedText(),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.05,
                    child: AnimatedSmoothIndicator(
                      activeIndex: _currentPageNotifier.value,
                      count: provider.recentlyWatchedAnimes.length,
                      effect: WormEffect(
                        dotColor: Theme.of(context).hintColor,
                        activeDotColor: Colors.white,
                        dotWidth: 8.0,
                        dotHeight: 8.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
