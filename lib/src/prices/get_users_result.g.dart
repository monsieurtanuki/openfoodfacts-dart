// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_users_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetUsersResult _$GetUsersResultFromJson(Map<String, dynamic> json) =>
    GetUsersResult()
      ..items = (json['items'] as List<dynamic>?)
          ?.map((e) => PriceUser.fromJson(e as Map<String, dynamic>))
          .toList()
      ..total = (json['total'] as num?)?.toInt()
      ..pageNumber = (json['page'] as num?)?.toInt()
      ..pageSize = (json['size'] as num?)?.toInt()
      ..numberOfPages = (json['pages'] as num?)?.toInt();

Map<String, dynamic> _$GetUsersResultToJson(GetUsersResult instance) =>
    <String, dynamic>{
      'items': instance.items,
      'total': instance.total,
      'page': instance.pageNumber,
      'size': instance.pageSize,
      'pages': instance.numberOfPages,
    };
