// Flutter imports:
import 'package:anime_twist_flut/pages/homepage/AppbarText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Project imports:
import '../../services/twist_service/TwistApiService.dart';
import '../../utils/search_page/SearchUtils.dart';
import 'SearchListTile.dart';
import 'SearchPageInputBox.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  TextEditingController _textEditingController;
  ScrollController _scrollController;
  FocusNode listTileNode;
  FocusNode backButtonNode;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: '');
    _scrollController = ScrollController();
    listTileNode = FocusNode();
    backButtonNode = FocusNode();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    listTileNode.dispose();
    backButtonNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: AppbarText(
          custom: 'search',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: SearchPageInputBox(
                  listTileFocusNode: listTileNode,
                  backButtonFocusNode: backButtonNode,
                  controller: _textEditingController,
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 5.0,
                  ),
                  child: Builder(
                    builder: (context) {
                      var results = <Widget>[];
                      for (var i = 0;
                          i < TwistApiService.allTwistModel.length;
                          i++) {
                        var elem = TwistApiService.allTwistModel.elementAt(i);
                        if (SearchUtils.isTextInAnimeModel(
                          text: _textEditingController.text,
                          twistModel: elem,
                        )) {
                          results.add(
                            SearchListTile(
                              isFirstResult: results.isEmpty,
                              twistModel: elem,
                              firstTileNode: listTileNode,
                              backButtonNode: backButtonNode,
                            ),
                          );
                        }
                      }
                      if (results.isEmpty) {
                        return ListTile(
                          title: Center(
                            child: Text('No results found :('),
                          ),
                        );
                      }
                      return Scrollbar(
                        controller: _scrollController,
                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => results[index],
                          itemCount: results.length,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
