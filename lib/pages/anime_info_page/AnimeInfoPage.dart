// Flutter imports:
import 'dart:ffi';
import 'dart:math';
import 'dart:ui';

import 'package:anime_twist_flut/providers.dart';
import 'package:anime_twist_flut/pages/anime_info_page/DescriptionWidget.dart';
import 'package:anime_twist_flut/pages/anime_info_page/RatingGraph.dart';
import 'package:anime_twist_flut/pages/anime_info_page/RatingWidget.dart';
import 'package:anime_twist_flut/pages/anime_info_page/WatchTrailerButton.dart';
import 'package:anime_twist_flut/pages/error_page/ErrorPage.dart';
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import 'package:anime_twist_flut/widgets/custom_shimmer.dart';
import 'package:anime_twist_flut/widgets/device_orientation_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:anime_twist_flut/utils/GetUtils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supercharged/supercharged.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:anime_twist_flut/pages/anime_info_page/episodes/EpisodesSliver.dart';
import '../../models/EpisodeModel.dart';
import '../../models/kitsu/KitsuModel.dart';
import '../../models/TwistModel.dart';
import '../../providers/EpisodesWatchedProvider.dart';
import '../../services/kitsu_service/KitsuApiService.dart';
import 'package:anime_twist_flut/constants.dart';
import '../../animations/TwistLoadingWidget.dart';

import 'FavouriteButton.dart';

class AnimeInfoPage extends StatefulWidget {
  final TwistModel twistModel;
  final bool isFromSearchPage;
  final FocusNode focusNode;
  final bool isFromRecentlyWatched;
  final int lastWatchedEpisodeNum;

  AnimeInfoPage({
    this.twistModel,
    this.isFromSearchPage,
    this.focusNode,
    this.isFromRecentlyWatched = false,
    this.lastWatchedEpisodeNum = 0,
  });

  @override
  State<StatefulWidget> createState() {
    return _AnimeInfoPageState();
  }
}

class _AnimeInfoPageState extends State<AnimeInfoPage> {
  ScrollController _scrollController;
  ScrollController _placeholderController;
  ChangeNotifierProvider<EpisodesWatchedProvider> _episodesWatchedProvider;
  bool hasScrolled = false;
  KitsuModel kitsuModel;
  List<EpisodeModel> episodes;
  FutureProvider _initDataProvider;

  final offsetProvider = StateProvider<double>((ref) {
    return 0.0;
  });

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _placeholderController = ScrollController();
    _scrollController.addListener(() {
      setImageOffset();
    });
    _initDataProvider = FutureProvider((ref) async {
      await initData();
    });
  }

  void setImageOffset() {
    var controller = _placeholderController;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      controller = _scrollController;

    }
    var offset = controller.offset / MediaQuery.of(context).size.height * 5;
    context.read(offsetProvider).state = offset;
  }

  @override
  void dispose() {
    Get.delete<TwistModel>();
    Get.delete<KitsuModel>();
    Get.delete<ChangeNotifierProvider<EpisodesWatchedProvider>>();
    _scrollController.dispose();
    _placeholderController.dispose();

    super.dispose();
  }

  Future initData() async {
    Get.delete<TwistModel>();
    Get.put<TwistModel>(widget.twistModel);

    var twistApiService = Get.find<TwistApiService>();


    episodes = await twistApiService.getEpisodesForSource(
      twistModel: widget.twistModel,
    );

    kitsuModel = await KitsuApiService.getKitsuModel(
        widget.twistModel.kitsuId, widget.twistModel.ongoing);

    Get.delete<KitsuModel>();
    Get.put<KitsuModel>(kitsuModel);

    await precacheImage(
        NetworkImage(kitsuModel?.posterImage ??
            (kitsuModel?.coverImage ?? DEFAULT_IMAGE_URL)),
        context);

    _episodesWatchedProvider = ChangeNotifierProvider<EpisodesWatchedProvider>(
      (ref) {
        return EpisodesWatchedProvider(slug: widget.twistModel.slug);
      },
    );

    await context.read(_episodesWatchedProvider).getWatchedPref();

    // Prevent content rendering in between the transition
    await Future.delayed(400.milliseconds);
  }

  // Scrolls to the latest watched episode if isFromRecentlyWatched is true and
  // a last watched episode number is provided.
  void scrollToLastWatched(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var height = MediaQuery.of(context).size.height;

    if (hasScrolled) return;
    if (widget.isFromRecentlyWatched && widget.lastWatchedEpisodeNum != null) {
      if (orientation == Orientation.portrait) {
        // Height of the expanded app bar which contains the image and other info
        var sliverAppBarHeight = height * 0.4;
        // Height of the widget which holds the description text
        var descHeight = 150;
        // Maximum distance our screen is able to scroll with the given contents
        var maxScrollExtent = _scrollController.position.maxScrollExtent;
        // Approximate height of each episode card. We use this to calculate how
        // much we need to scroll by multiplying it by our last watched episode.
        var episodeCardHeight =
            (maxScrollExtent - (sliverAppBarHeight + descHeight)) /
                episodes.length;

        var scrollLength = sliverAppBarHeight +
            descHeight +
            (widget.lastWatchedEpisodeNum * episodeCardHeight);

        // Don't overscroll if our calculated scroll length is greater than the
        // maximum
        if (scrollLength > maxScrollExtent) scrollLength = maxScrollExtent;

        var duration = max(1000, widget.lastWatchedEpisodeNum * 10);

        _scrollController
            .animateTo(
              scrollLength,
              duration: duration.milliseconds,
              curve: Curves.ease,
            )
            .whenComplete(() => hasScrolled = true);
      } else {
        var cardHeight =
            _scrollController.position.maxScrollExtent / episodes.length;
        var scrollLength = cardHeight * widget.lastWatchedEpisodeNum;
        var duration = max(1000, widget.lastWatchedEpisodeNum * 10);

        _scrollController
            .animateTo(
              scrollLength,
              duration: duration.milliseconds,
              curve: Curves.ease,
            )
            .whenComplete(() => hasScrolled = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        return true;
      },
      child: Scaffold(
        body: Consumer(
          builder: (context, watch, child) {
            return watch(_initDataProvider).when(
              data: (data) {
                WidgetsBinding.instance.addPostFrameCallback(
                    (timeStamp) => scrollToLastWatched(context));
                return DeviceOrientationBuilder(
                  portrait: Scrollbar(
                    controller: _scrollController,
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverAppBar(
                          expandedHeight: orientation == Orientation.portrait
                              ? height * 0.4
                              : width * 0.28,
                          stretch: true,
                          actions: [RatingWidget(kitsuModel: kitsuModel)],
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Positioned.fill(
                                    child: Consumer(
                                      builder: (context, watch, child) {
                                        final provider = watch(offsetProvider);
                                        return CachedNetworkImage(
                                          imageUrl: kitsuModel?.posterImage ??
                                              kitsuModel?.coverImage ??
                                              DEFAULT_IMAGE_URL,
                                          fit: BoxFit.cover,
                                          alignment: Alignment(
                                              0, -provider.state.abs()),
                                          placeholder: (_, __) =>
                                              CustomShimmer(),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      color: Theme.of(context)
                                          .cardColor
                                          .withOpacity(0.1),
                                    ),
                                  ),
                                  Positioned.fill(
                                    bottom: 20,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            fit: FlexFit.loose,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: AutoSizeText(
                                                    widget.twistModel.title
                                                        .toUpperCase(),
                                                    textAlign: TextAlign.left,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    minFontSize: 20.0,
                                                    style: TextStyle(

                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 30.0,
                                                    ),
                                                  ),
                                                ),
                                                Consumer(
                                                  builder:
                                                      (context, watch, child) {
                                                    final provider =
                                                        watch(toWatchProvider);
                                                    return Container(
                                                      height: 35.0,
                                                      margin: EdgeInsets.only(
                                                        left: 5.0,
                                                      ),
                                                      child: IconButton(
                                                        icon: Icon(
                                                          provider.isAlreadyInToWatch(
                                                                      widget
                                                                          .twistModel) >=
                                                                  0
                                                              ? FontAwesomeIcons
                                                                  .minus
                                                              : FontAwesomeIcons
                                                                  .plus,
                                                        ),
                                                        onPressed: () {
                                                          provider
                                                              .toggleFromToWatched(
                                                            episodeModel: null,
                                                            kitsuModel:
                                                                kitsuModel,
                                                            twistModel: widget
                                                                .twistModel,
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5.0),
                                          Text(
                                            (episodes?.length?.toString() ??
                                                    '0') +
                                                ' Episodes | ' +
                                                (widget.twistModel.ongoing
                                                    ? 'Ongoing'
                                                    : 'Finished'),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color:
                                                  Theme.of(context).hintColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Row(
                                children: [
                                  Expanded(
                                    child: WatchTrailerButton(
                                      kitsuModel: kitsuModel,
                                    ),
                                  ),
                                  FavouriteButton(
                                    twistModel: widget.twistModel,
                                    kitsuModel: kitsuModel,
                                  ),
                                ],
                              ),
                              DescriptionWidget(
                                twistModel: widget.twistModel,
                                kitsuModel: kitsuModel,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  bottom: 8.0,
                                ),
                                child: Text(
                                  'SEASON ' +
                                      widget.twistModel.season.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                    if(showEpisodes)   EpisodesSliver(

                          episodes: episodes,
                          episodesWatchedProvider: _episodesWatchedProvider,
                    ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 15.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  landscape: Row(
                    children: [
                      Expanded(
                        child: CustomScrollView(
                          controller: _placeholderController,
                          slivers: [
                            SliverAppBar(
                              expandedHeight:
                                  orientation == Orientation.portrait
                                      ? height * 0.4
                                      : width * 0.28,
                              stretch: true,
                              actions: [RatingWidget(kitsuModel: kitsuModel)],
                              flexibleSpace: FlexibleSpaceBar(
                                background: Container(
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Positioned.fill(
                                        child: Consumer(
                                          builder: (context, watch, child) {
                                            final provider =
                                                watch(offsetProvider);
                                            return CachedNetworkImage(
                                              imageUrl:
                                                  kitsuModel?.posterImage ??
                                                      kitsuModel?.coverImage ??
                                                      DEFAULT_IMAGE_URL,
                                              fit: BoxFit.cover,
                                              alignment: Alignment(
                                                  0, -provider.state.abs()),
                                              placeholder: (_, __) =>
                                                  CustomShimmer(),
                                            );
                                          },
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          color: Theme.of(context)
                                              .cardColor
                                              .withOpacity(0.7),
                                        ),
                                      ),
                                      Positioned.fill(
                                        bottom: 20,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 20.0,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: AutoSizeText(
                                                        widget.twistModel.title
                                                            .toUpperCase(),
                                                        textAlign:
                                                            TextAlign.left,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        minFontSize: 20.0,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 30.0,
                                                        ),
                                                      ),
                                                    ),
                                                    Consumer(
                                                      builder: (context, watch,
                                                          child) {
                                                        final provider = watch(
                                                            toWatchProvider);
                                                        return Container(
                                                          height: 35.0,
                                                          margin:
                                                              EdgeInsets.only(
                                                            left: 5.0,
                                                          ),
                                                          child: IconButton(
                                                            icon: Icon(
                                                              provider.isAlreadyInToWatch(
                                                                          widget
                                                                              .twistModel) >=
                                                                      0
                                                                  ? FontAwesomeIcons
                                                                      .minus
                                                                  : FontAwesomeIcons
                                                                      .plus,
                                                            ),
                                                            onPressed: () {
                                                              provider
                                                                  .toggleFromToWatched(
                                                                episodeModel:
                                                                    null,
                                                                kitsuModel:
                                                                    kitsuModel,
                                                                twistModel: widget
                                                                    .twistModel,
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 5.0),
                                              Text(
                                                (episodes?.length?.toString() ??
                                                        '0') +
                                                    ' Episodes | ' +
                                                    (widget.twistModel.ongoing
                                                        ? 'Ongoing'
                                                        : 'Finished'),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: WatchTrailerButton(
                                          kitsuModel: kitsuModel,
                                        ),
                                      ),
                                      FavouriteButton(
                                        twistModel: widget.twistModel,
                                        kitsuModel: kitsuModel,
                                      ),
                                    ],
                                  ),
                                  DescriptionWidget(
                                    twistModel: widget.twistModel,
                                    kitsuModel: kitsuModel,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: RatingGraph(
                                        ratingFrequencies:
                                            kitsuModel.ratingFrequencies),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: SafeArea(
                        child: Scrollbar(
                          controller: _scrollController,
                          child: CustomScrollView(
                            controller: _scrollController,
                            slivers: [
                              SliverToBoxAdapter(
                                child: Container(
                                  padding: EdgeInsets.only(
                                    left: 16.0,
                                    right: 16.0,
                                    bottom: 8.0,
                                    top: 8.0,
                                  ),
                                  child: Text(
                                    'SEASON ' +
                                        widget.twistModel.season.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ),
                              EpisodesSliver(
                                episodesWatchedProvider:
                                    _episodesWatchedProvider,
                                episodes: episodes,
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                );
              },
              loading: () => Center(child: RotatingPinLoadingAnimation()),
              error: (e, s) => ErrorPage(
                stackTrace: s,
                e: e,
                message:
                    'Whoops! An error occured. Looks like twist.moe is down, or your internet is not working. Please try again later.',
                onRefresh: () => context.refresh(_initDataProvider),
              ),
            );
     },
        ),
      ),
    );
  }
}
