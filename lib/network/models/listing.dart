import 'package:json_annotation/json_annotation.dart';
import 'package:netshells_flutter_test/network/models/listing_data.dart';

// this is necessary for the generated code to find your class
part 'listing.g.dart';

@JsonSerializable()
class Listing {
  String? kind;

  ListingData? data;

  Listing(
    this.kind,
    this.data,
  );

  factory Listing.fromJson(final Map<String, dynamic> json) {
    return _$ListingFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ListingToJson(this);
}
