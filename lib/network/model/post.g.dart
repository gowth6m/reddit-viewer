// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      author: json['author'] as String?,
      title: json['title'] as String?,
      selftext: json['selftext'] as String?,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'author': instance.author,
      'title': instance.title,
      'selftext': instance.selftext,
    };
