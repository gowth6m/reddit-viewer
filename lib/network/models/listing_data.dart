import 'package:json_annotation/json_annotation.dart';
import 'package:netshells_flutter_test/network/models/t3.dart';

part 'listing_data.g.dart';

@JsonSerializable()
class ListingData {
  ListingData({
    this.dist,
    this.children,
  });

  int? dist;
  List<T3>? children;

  factory ListingData.fromJson(Map<String, dynamic> json) =>
      _$ListingDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListingDataToJson(this);
}
