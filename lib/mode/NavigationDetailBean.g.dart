// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NavigationDetailBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NavigationDetailBean _$NavigationDetailBeanFromJson(Map<String, dynamic> json) {
  return NavigationDetailBean(
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : Data.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['errorCode'] as int,
      json['errorMsg'] as String);
}

Map<String, dynamic> _$NavigationDetailBeanToJson(
        NavigationDetailBean instance) =>
    <String, dynamic>{
      'data': instance.data,
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
      (json['articles'] as List)
          ?.map((e) =>
              e == null ? null : Articles.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['cid'] as int,
      json['name'] as String);
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'articles': instance.articles,
      'cid': instance.cid,
      'name': instance.name
    };

Articles _$ArticlesFromJson(Map<String, dynamic> json) {
  return Articles(
      json['apkLink'] as String,
      json['author'] as String,
      json['chapterId'] as int,
      json['chapterName'] as String,
      json['collect'] as bool,
      json['courseId'] as int,
      json['desc'] as String,
      json['envelopePic'] as String,
      json['fresh'] as bool,
      json['id'] as int,
      json['link'] as String,
      json['niceDate'] as String,
      json['origin'] as String,
      json['prefix'] as String,
      json['projectLink'] as String,
      json['publishTime'] as int,
      json['superChapterId'] as int,
      json['superChapterName'] as String,
      json['tags'] as List,
      json['title'] as String,
      json['type'] as int,
      json['userId'] as int,
      json['visible'] as int,
      json['zan'] as int);
}

Map<String, dynamic> _$ArticlesToJson(Articles instance) => <String, dynamic>{
      'apkLink': instance.apkLink,
      'author': instance.author,
      'chapterId': instance.chapterId,
      'chapterName': instance.chapterName,
      'collect': instance.collect,
      'courseId': instance.courseId,
      'desc': instance.desc,
      'envelopePic': instance.envelopePic,
      'fresh': instance.fresh,
      'id': instance.id,
      'link': instance.link,
      'niceDate': instance.niceDate,
      'origin': instance.origin,
      'prefix': instance.prefix,
      'projectLink': instance.projectLink,
      'publishTime': instance.publishTime,
      'superChapterId': instance.superChapterId,
      'superChapterName': instance.superChapterName,
      'tags': instance.tags,
      'title': instance.title,
      'type': instance.type,
      'userId': instance.userId,
      'visible': instance.visible,
      'zan': instance.zan
    };
