// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListingData _$ListingDataFromJson(Map<String, dynamic> json) => ListingData(
      dist: json['dist'] as int?,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => T3.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListingDataToJson(ListingData instance) =>
    <String, dynamic>{
      'dist': instance.dist,
      'children': instance.children,
    };
