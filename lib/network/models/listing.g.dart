// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Listing _$ListingFromJson(Map<String, dynamic> json) => Listing(
      json['kind'] as String?,
      json['data'] == null
          ? null
          : ListingData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListingToJson(Listing instance) => <String, dynamic>{
      'kind': instance.kind,
      'data': instance.data,
    };
