// Flutter imports:
import 'package:anime_twist_flut/pages/homepage/donation_card/GenericDonationSheet.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:anime_twist_flut/utils/GetUtils.dart';

// Project imports:
import 'package:anime_twist_flut/services/twist_service/TwistApiService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../utils/homepage/DonationUtils.dart';
import '../../../animations/TwistLoadingWidget.dart';

class DonationCard extends StatefulWidget {
  const DonationCard({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DonationCardState();
  }
}

class _DonationCardState extends State<DonationCard>
    with AutomaticKeepAliveClientMixin {
  final _dataInitProvider = FutureProvider.autoDispose<List<int>>((ref) async {
    var twistApiService = Get.find<TwistApiService>();
    return twistApiService.getDonationsData();
  });

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer(builder: (context, watch, child) {
      return watch(_dataInitProvider).when(
        data: (data) {
          int currentAmount, totalAmount;
          if (data.isNotEmpty) {
            currentAmount = data[0];
            totalAmount = data[1];
          }
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(8.0),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            ListTile(
                              autofocus: true,
                              title: Text('Back'),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            // ListTile(
                            //   title: Text('Patreon'),
                            //   onTap: () {
                            //     DonationUtils.donatePatreon();
                            //   },
                            // ),
                            ListTile(
                              title: Text('Bitcoin'),
                              onTap: () {
                                showModalBottomSheet<dynamic>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => GenericDonationSheet(
                                    name: 'Bitcoin',
                                    address:
                                        '1ATvQNxFnyVBa4Pd5njdvjTXcECgptzcZo',
                                    qrURL:
                                        'https://twist.moe/public/img/bitcoin-qr.png',
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: Text('Ethereum'),
                              onTap: () {
                                showModalBottomSheet<dynamic>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => GenericDonationSheet(
                                    name: 'Ethereum',
                                    address:
                                        '0x8337104096a3297a71ee16a9C922a5ff3818DF46',
                                    qrURL:
                                        'https://twist.moe/public/img/ethereum-qr.png',
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 15.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Donations',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20.0,
                              // color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            (currentAmount?.toString() ?? '?') +
                                ' / ' +
                                (totalAmount?.toString() ?? '?'),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      child: LinearProgressIndicator(
                        value: (currentAmount ?? 0.0) / (totalAmount ?? 1.0),
                        backgroundColor:
                            Theme.of(context).accentColor.withOpacity(
                                  0.5,
                                ),
                      ),
                    ),
                    Text(
                      'Tap to contribute!',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Theme.of(context)
                            .textTheme
                            .headline6
                            .color
                            .withOpacity(
                              0.7,
                            ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => Card(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(
                35,
              ),
              child: Transform.scale(
                scale: 0.4,
                child: RotatingPinLoadingAnimation(),
              ),
            ),
          ),
        ),
        error: (error, stacktrace) => Card(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Failed to get donation data'),
                  ElevatedButton(
                    onPressed: () => context.refresh(_dataInitProvider),
                    child: Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
