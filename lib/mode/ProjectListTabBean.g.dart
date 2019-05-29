// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProjectListTabBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectListTabBean _$ProjectListTabBeanFromJson(Map<String, dynamic> json) {
  return ProjectListTabBean(
      (json['data'] as List)
          ?.map((e) => e == null
              ? null
              : ProjectListTabData.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['errorCode'] as int,
      json['errorMsg'] as String);
}

Map<String, dynamic> _$ProjectListTabBeanToJson(ProjectListTabBean instance) =>
    <String, dynamic>{
      'data': instance.data,
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg
    };

ProjectListTabData _$ProjectListTabDataFromJson(Map<String, dynamic> json) {
  return ProjectListTabData(
      json['children'] as List,
      json['courseId'] as int,
      json['id'] as int,
      json['name'] as String,
      json['order'] as int,
      json['parentChapterId'] as int,
      json['userControlSetTop'] as bool,
      json['visible'] as int);
}

Map<String, dynamic> _$ProjectListTabDataToJson(ProjectListTabData instance) =>
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
