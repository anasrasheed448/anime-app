// Flutter imports:
import 'package:anime_twist_flut/pages/homepage/AppbarText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import '../../services/twist_service/TwistApiService.dart';
import '../search_page/SearchListTile.dart';

class AllAnimePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AllAnimePageState();
  }
}

class _AllAnimePageState extends State<AllAnimePage> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // _previousScrollOffset = _controller.offset;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: AppbarText(),
          actions: [
            IconButton(
              icon: Icon(
                FontAwesomeIcons.chevronUp,
              ),
              onPressed: () {
                _controller.animateTo(
                  0.0,
                  duration: Duration(
                    milliseconds: _controller.offset ~/ 5,
                  ),
                  curve: Curves.ease,
                );
              },
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.chevronDown,
              ),
              onPressed: () {
                _controller.animateTo(
                  _controller.position.maxScrollExtent,
                  duration: Duration(
                    milliseconds: _controller.offset != 0
                        ? (_controller.position.maxScrollExtent -
                                _controller.offset) ~/
                            5
                        : _controller.position.maxScrollExtent ~/ 5,
                  ),
                  curve: Curves.ease,
                );
              },
            ),
          ],
          elevation: 0.0,
        ),
        body: Scrollbar(
          controller: _controller,
          child: ListView.builder(
            controller: _controller,
            itemBuilder: (context, index) {
              var twistModel = TwistApiService.allTwistModel.elementAt(index);
              return SearchListTile(
                twistModel: twistModel,
              );
            },
            itemCount: TwistApiService.allTwistModel.length,
          ),
        ),
      ),
    );
  }
}
