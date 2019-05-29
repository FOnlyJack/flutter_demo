// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RegisterResultBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterResultBean _$RegisterResultBeanFromJson(Map<String, dynamic> json) {
  return RegisterResultBean(
      json['errorCode'] as int, json['errorMsg'] as String)
    ..data = json['data'] == null
        ? null
        : Data.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$RegisterResultBeanToJson(RegisterResultBean instance) =>
    <String, dynamic>{
      'data': instance.data,
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
      json['admin'] as bool,
      json['chapterTops'] as List,
      json['collectIds'] as List,
      json['email'] as String,
      json['icon'] as String,
      json['id'] as int,
      json['password'] as String,
      json['token'] as String,
      json['type'] as int,
      json['username'] as String);
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'admin': instance.admin,
      'chapterTops': instance.chapterTops,
      'collectIds': instance.collectIds,
      'email': instance.email,
      'icon': instance.icon,
      'id': instance.id,
      'password': instance.password,
      'token': instance.token,
      'type': instance.type,
      'username': instance.username
    };
