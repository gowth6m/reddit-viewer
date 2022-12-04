import 'package:json_annotation/json_annotation.dart';

part 't3_data.g.dart';

@JsonSerializable()
class T3Data {
  T3Data({
    this.author,
    this.title,
    this.selftext,
  });

  String? author;
  String? title;
  String? selftext;

  factory T3Data.fromJson(Map<String, dynamic> json) => _$T3DataFromJson(json);

  Map<String, dynamic> toJson() => _$T3DataToJson(this);
}
