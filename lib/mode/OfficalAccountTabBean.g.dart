// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OfficalAccountTabBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfficalAccountTabBean _$OfficalAccountTabBeanFromJson(
    Map<String, dynamic> json) {
  return OfficalAccountTabBean(
      (json['data'] as List)
          ?.map((e) => e == null
              ? null
              : OfficalAccountTabData.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['errorCode'] as int,
      json['errorMsg'] as String);
}

Map<String, dynamic> _$OfficalAccountTabBeanToJson(
        OfficalAccountTabBean instance) =>
    <String, dynamic>{
      'data': instance.data,
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg
    };

OfficalAccountTabData _$OfficalAccountTabDataFromJson(
    Map<String, dynamic> json) {
  return OfficalAccountTabData(
      json['children'] as List,
      json['courseId'] as int,
      json['id'] as int,
      json['name'] as String,
      json['order'] as int,
      json['parentChapterId'] as int,
      json['userControlSetTop'] as bool,
      json['visible'] as int);
}

Map<String, dynamic> _$OfficalAccountTabDataToJson(
        OfficalAccountTabData instance) =>
    <String, dynamic>{
      'children': instance.children,
      'courseId': instance.courseId,
      'id': instance.id,
      'name': instance.name,
      'order': instance.order,
      'parentChapterId': instance.parentChapterId,
      'userControlSetTop': instance.userControlSetTop,
      'visible': instance.visible
    };
