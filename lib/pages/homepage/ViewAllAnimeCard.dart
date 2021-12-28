// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import '../../animations/Transitions.dart';
import '../../pages/all_anime_page/AllAnimePage.dart';

class ViewAllAnimeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () {
          Transitions.slideTransition(
            context: context,
            pageBuilder: () => AllAnimePage(),
          );
        },
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(
            horizontal: 15.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                child: Text(
                  'View All Anime',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(
                Icons.navigate_next,
                size: 28.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
