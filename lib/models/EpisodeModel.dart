// Package imports:
import 'package:hive/hive.dart';

part 'EpisodeModel.g.dart';

@HiveType(typeId: 2)
class EpisodeModel extends HiveObject {
  @HiveField(0)
  final String source;

  @HiveField(1)
  final int number;

  EpisodeModel({this.source, this.number});

  factory EpisodeModel.fromJson(Map<String, dynamic> data) {
    return EpisodeModel(
      source: data['source'],
      number: data['number'],
    );
  }
}
