import 'package:json_annotation/json_annotation.dart';
import 'package:reddit_viewer/network/model/t3_data.dart';

part 't3.g.dart';

@JsonSerializable()
class T3 {
  T3({
    this.kind,
    this.data,
  });

  String? kind;
  T3Data? data;

  factory T3.fromJson(Map<String, dynamic> json) =>
      _$T3FromJson(json);

  Map<String, dynamic> toJson() => _$T3ToJson(this);
}
