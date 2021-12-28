import 'KitsuModel.dart';

class KitsuAnimeListModel {
  List<KitsuModel> kitsuModels;
  Meta meta;
  Links links;

  KitsuAnimeListModel({this.kitsuModels, this.meta, this.links});

  KitsuAnimeListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      kitsuModels = <KitsuModel>[];
      json['data'].forEach((v) {
        kitsuModels.add(KitsuModel.fromJson(v, true));
      });
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
  }
}

class Meta {
  int count;

  Meta({this.count});

  Meta.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['count'] = count;
    return data;
  }
}

class Links {
  String first;
  String next;
  String last;

  Links({this.first, this.next, this.last});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    next = json['next'];
    last = json['last'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['first'] = first;
    data['next'] = next;
    data['last'] = last;
    return data;
  }
}
