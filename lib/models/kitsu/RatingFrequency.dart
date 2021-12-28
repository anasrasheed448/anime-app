import 'package:hive/hive.dart';

part 'RatingFrequency.g.dart';

@HiveType(typeId: 5)
class RatingFrequencies {
  @HiveField(0)
  String s2;
  @HiveField(1)
  String s3;
  @HiveField(2)
  String s4;
  @HiveField(3)
  String s5;
  @HiveField(4)
  String s6;
  @HiveField(5)
  String s7;
  @HiveField(6)
  String s8;
  @HiveField(7)
  String s9;
  @HiveField(8)
  String s10;
  @HiveField(9)
  String s11;
  @HiveField(10)
  String s12;
  @HiveField(11)
  String s13;
  @HiveField(12)
  String s14;
  @HiveField(13)
  String s15;
  @HiveField(14)
  String s16;
  @HiveField(15)
  String s17;
  @HiveField(16)
  String s18;
  @HiveField(17)
  String s19;
  @HiveField(18)
  String s20;

  RatingFrequencies(
      {this.s2,
      this.s3,
      this.s4,
      this.s5,
      this.s6,
      this.s7,
      this.s8,
      this.s9,
      this.s10,
      this.s11,
      this.s12,
      this.s13,
      this.s14,
      this.s15,
      this.s16,
      this.s17,
      this.s18,
      this.s19,
      this.s20});

  RatingFrequencies.fromJson(Map<String, dynamic> json) {
    s2 = json['2'];
    s3 = json['3'];
    s4 = json['4'];
    s5 = json['5'];
    s6 = json['6'];
    s7 = json['7'];
    s8 = json['8'];
    s9 = json['9'];
    s10 = json['10'];
    s11 = json['11'];
    s12 = json['12'];
    s13 = json['13'];
    s14 = json['14'];
    s15 = json['15'];
    s16 = json['16'];
    s17 = json['17'];
    s18 = json['18'];
    s19 = json['19'];
    s20 = json['20'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['2'] = s2;
    data['3'] = s3;
    data['4'] = s4;
    data['5'] = s5;
    data['6'] = s6;
    data['7'] = s7;
    data['8'] = s8;
    data['9'] = s9;
    data['10'] = s10;
    data['11'] = s11;
    data['12'] = s12;
    data['13'] = s13;
    data['14'] = s14;
    data['15'] = s15;
    data['16'] = s16;
    data['17'] = s17;
    data['18'] = s18;
    data['19'] = s19;
    data['20'] = s20;
    return data;
  }

  List<String> get alternateList {
    return [
      s2,
      s4,
      s6,
      s8,
      s10,
      s12,
      s14,
      s16,
      s18,
      s20,
    ];
  }
}
