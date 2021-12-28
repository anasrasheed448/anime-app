import 'package:anime_twist_flut/models/kitsu/RatingFrequency.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RatingGraph extends StatelessWidget {
  const RatingGraph({Key key, @required this.ratingFrequencies})
      : super(key: key);

  final RatingFrequencies ratingFrequencies;

  List<FlSpot> getGraphSpots() {
    var ret = <FlSpot>[];
    var i = 0;
    for (var rating in ratingFrequencies.alternateList) {
      ret.add(
        FlSpot(
          i.toDouble(),
          int.parse(rating ?? '0').toDouble(),
        ),
      );
      i++;
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var orientation = MediaQuery.of(context).orientation;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      height: orientation == Orientation.portrait
          ? size.height * 0.25
          : size.width * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).cardColor,
      ),
      child: LineChart(
        LineChartData(
          backgroundColor: Theme.of(context).cardColor,
          borderData: FlBorderData(show: false),
          axisTitleData: FlAxisTitleData(
            bottomTitle: AxisTitle(
                showTitle: true,
                titleText: 'Ratings',
                textStyle: TextStyle(
                  color: Colors.white,
                )),
          ),
          titlesData: FlTitlesData(
            leftTitles: SideTitles(showTitles: false),
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) => TextStyle(
                color: Theme.of(context).hintColor,
              ),
              getTitles: (value) => (value.ceil() + 1).toString(),
            ),
          ),
          gridData: FlGridData(
            show: false,
          ),
          lineBarsData: [
            LineChartBarData(
              dotData: FlDotData(show: false),
              isCurved: true,
              preventCurveOverShooting: true,
              colors: [Theme.of(context).accentColor],
              belowBarData: BarAreaData(
                colors: [Theme.of(context).accentColor.withOpacity(0.3)],
                show: true,
              ),
              spots: getGraphSpots(),
            ),
          ],
        ),
      ),
    );
  }
}
