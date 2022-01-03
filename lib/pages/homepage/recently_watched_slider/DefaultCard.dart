import 'package:anime_twist_flut/animations/Transitions.dart';
import 'package:anime_twist_flut/constants.dart';
import 'package:anime_twist_flut/pages/all_anime_page/AllAnimePage.dart';
import 'package:anime_twist_flut/widgets/custom_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DefaultCard extends StatelessWidget {
  DefaultCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //  DeviceOrientation.portraitUp,
    //  DeviceOrientation.portraitDown,
    //]);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var orientation = MediaQuery.of(context).orientation;

    var containerHeight =
        orientation == Orientation.portrait ? height * 0.4 : width * 0.3;
    return Container(
      width: double.infinity,
      height: containerHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: DEFAULT_IMAGE_URL,
              fit: BoxFit.cover,
              placeholder: (context, url) => CustomShimmer(),
            ),
          ),
          Positioned.fill(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Theme.of(context).cardColor.withOpacity(0.7),
            ),
          ),
          Positioned(
            bottom: orientation == Orientation.portrait
                ? height * 0.3
                : width * 0.225,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(
                  20.0,
                ),
              ),
              child: Text(
                'Recently Watched'.toUpperCase(),
                style: TextStyle(
                  letterSpacing: 1.25,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 30.0,
            ),
            child: Text(
              "Looks like you haven't watched anything yet!",
              textAlign: TextAlign.center,
              maxLines: 2,
              // minFontSize: 17.0,
              overflow: TextOverflow.visible,
              style: TextStyle(
                letterSpacing: 1.0,
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
              ),
            ),
          ),
          Positioned(
            bottom: orientation == Orientation.portrait
                ? height * 0.03
                : width * 0.03,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Start Watching'.toUpperCase(),
                    style: TextStyle(
                      letterSpacing: 1.25,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12.0,
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Transitions.slideTransition(
                    context: context,
                    pageBuilder: () => AllAnimePage(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
