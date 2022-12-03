// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkPostsList _$NetworkPostsListFromJson(Map<String, dynamic> json) =>
    NetworkPostsList(
      json['kind'] as String,
      (json['data'] as List<dynamic>?)
          ?.map((e) => PostData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NetworkPostsListToJson(NetworkPostsList instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'data': instance.data,
    };
