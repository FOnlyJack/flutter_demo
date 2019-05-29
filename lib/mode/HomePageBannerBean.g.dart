// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HomePageBannerBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomePageBannerBean _$HomePageBannerBeanFromJson(Map<String, dynamic> json) {
  return HomePageBannerBean(
      (json['data'] as List)
          ?.map((e) => e == null
              ? null
              : HomePageBannerData.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['errorCode'] as int,
      json['errorMsg'] as String);
}

Map<String, dynamic> _$HomePageBannerBeanToJson(HomePageBannerBean instance) =>
    <String, dynamic>{
      'data': instance.data,
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg
    };

HomePageBannerData _$HomePageBannerDataFromJson(Map<String, dynamic> json) {
  return HomePageBannerData(
      json['desc'] as String,
      json['id'] as int,
      json['imagePath'] as String,
      json['isVisible'] as int,
      json['order'] as int,
      json['title'] as String,
      json['type'] as int,
      json['url'] as String);
}

Map<String, dynamic> _$HomePageBannerDataToJson(HomePageBannerData instance) =>
    <String, dynamic>{
      'desc': instance.desc,
      'id': instance.id,
      'imagePath': instance.imagePath,
      'isVisible': instance.isVisible,
      'order': instance.order,
      'title': instance.title,
      'type': instance.type,
      'url': instance.url
    };
