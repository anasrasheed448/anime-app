// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:anime_twist_flut/utils/GetUtils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supercharged/supercharged.dart';

// Project imports:
import '../../animations/TwistLoadingWidget.dart';
import '../../services/twist_service/TwistApiService.dart';

class MOTDCard extends StatefulWidget {
  const MOTDCard({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MOTDCardState();
  }
}

class _MOTDCardState extends State<MOTDCard>
    with AutomaticKeepAliveClientMixin {
  bool shouldShow = true;

  final _dataInitProvider =
      FutureProvider.autoDispose<List<String>>((ref) async {
    var twistApiService = Get.find<TwistApiService>();
    return twistApiService.getMOTD();
  });

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer(
      builder: (context, watch, child) {
        return watch(_dataInitProvider).when(
          data: (data) => AnimatedSwitcher(
            duration: 500.milliseconds,
            child: shouldShow
                ? Padding(
                    padding: EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                      bottom: 15.0,
                    ),
                    child: Card(
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                                top: 15.0,
                                bottom: 10.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    data[0],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        shouldShow = false;
                                      });
                                    },
                                    child: Icon(
                                      Icons.close_rounded,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 20.0,
                                left: 15.0,
                                right: 15.0,
                              ),
                              child: Text(
                                data[1],
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
          ),
          loading: () => Padding(
            padding: EdgeInsets.only(
              left: 15.0,
              right: 15.0,
              bottom: 15.0,
            ),
            child: Card(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(
                    35.0,
                  ),
                  child: Transform.scale(
                    scale: 0.4,
                    child: RotatingPinLoadingAnimation(),
                  ),
                ),
              ),
            ),
          ),
          error: (e, s) => Padding(
            padding: EdgeInsets.only(
              left: 15.0,
              right: 15.0,
              bottom: 15.0,
            ),
            child: Card(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Failed to get MOTD'),
                      ElevatedButton(
                        onPressed: () => context.refresh(_dataInitProvider),
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
