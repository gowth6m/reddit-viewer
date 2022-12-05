// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't3.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

T3 _$T3FromJson(Map<String, dynamic> json) => T3(
      kind: json['kind'] as String?,
      data: json['data'] == null
          ? null
          : T3Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$T3ToJson(T3 instance) => <String, dynamic>{
      'kind': instance.kind,
      'data': instance.data,
    };
