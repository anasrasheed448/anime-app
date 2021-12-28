// Package imports:
import 'dart:convert';

import 'package:anime_twist_flut/models/kitsu/RatingFrequency.dart';
import 'package:hive/hive.dart';

part 'KitsuModel.g.dart';

@HiveType(typeId: 1)
class KitsuModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String rating;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String posterImage;

  @HiveField(4)
  final String trailerURL;

  @HiveField(5)
  final String coverImage;

  @HiveField(6)
  final RatingFrequencies ratingFrequencies;

  @HiveField(7)
  final String Hastags;

  KitsuModel({
    this.id,
    this.rating,
    this.description,
    this.posterImage,
    this.trailerURL,
    this.coverImage,
    this.ratingFrequencies,
    this.Hastags,
  });

  factory KitsuModel.fromJson(Map<String, dynamic> data,
      [bool isNested = false]) {
    var innerData = data['data'];
    if (isNested) innerData = data;

    var coverData = innerData['attributes']['coverImage'];
    var posterData = innerData['attributes']['posterImage'];
    var tags = innerData['attributes']['categories'];
    return KitsuModel(
      id: innerData['id'],
      rating: innerData['attributes']['averageRating'],
      posterImage: posterData != null ? posterData['large'] : null,
      description: utf8
          .decode((innerData['attributes']['synopsis'] as String).codeUnits),
      trailerURL: innerData['attributes']['youtubeVideoId'],
      coverImage: coverData != null ? coverData['large'] : null,
      ratingFrequencies: innerData['attributes']['ratingFrequencies'] != null
          ? RatingFrequencies.fromJson(
              innerData['attributes']['ratingFrequencies'])
          : null,
      Hastags: innerData['attributes']['categories'],
    );
  }
}
