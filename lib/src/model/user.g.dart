// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      comment: json['comment'] as String?,
      userId: json['user_id'] as String,
      password: json['password'] as String,
      cookie: json['cookie'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('comment', instance.comment);
  val['user_id'] = instance.userId;
  val['password'] = instance.password;
  val['cookie'] = instance.cookie;
  return val;
}
