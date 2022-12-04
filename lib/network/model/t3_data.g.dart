// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't3_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

T3Data _$T3DataFromJson(Map<String, dynamic> json) => T3Data(
      author: json['author'] as String?,
      title: json['title'] as String?,
      selftext: json['selftext'] as String?,
      url: json['url'] as String?,
      permalink: json['permalink'] as String?,
      link_flair_text: json['link_flair_text'] as String?,
    );

Map<String, dynamic> _$T3DataToJson(T3Data instance) => <String, dynamic>{
      'author': instance.author,
      'title': instance.title,
      'selftext': instance.selftext,
      'url': instance.url,
      'permalink': instance.permalink,
      'link_flair_text': instance.link_flair_text,
    };
