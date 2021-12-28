// Package imports:
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'FavouritedModel.g.dart';

@HiveType(typeId: 4)
class FavouritedModel extends HiveObject {
  @HiveField(0)
  final String slug;
  @HiveField(1)
  final String coverURL;
  @HiveField(2)
  final String posterURL;

  FavouritedModel({
    @required this.slug,
    @required this.coverURL,
    @required this.posterURL,
  });
}
