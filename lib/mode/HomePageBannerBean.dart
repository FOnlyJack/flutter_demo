import 'package:json_annotation/json_annotation.dart';

part 'HomePageBannerBean.g.dart';


@JsonSerializable()
class HomePageBannerBean  {

  @JsonKey(name: 'data')
  List<HomePageBannerData> data;

  @JsonKey(name: 'errorCode')
  int errorCode;

  @JsonKey(name: 'errorMsg')
  String errorMsg;

  HomePageBannerBean(this.data,this.errorCode,this.errorMsg,);

  factory HomePageBannerBean.fromJson(Map<String, dynamic> srcJson) => _$HomePageBannerBeanFromJson(srcJson);

}


@JsonSerializable()
class HomePageBannerData{

  @JsonKey(name: 'desc')
  String desc;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'imagePath')
  String imagePath;

  @JsonKey(name: 'isVisible')
  int isVisible;

  @JsonKey(name: 'order')
  int order;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'type')
  int type;

  @JsonKey(name: 'url')
  String url;

  HomePageBannerData(this.desc,this.id,this.imagePath,this.isVisible,this.order,this.title,this.type,this.url,);

  factory HomePageBannerData.fromJson(Map<String, dynamic> srcJson) => _$HomePageBannerDataFromJson(srcJson);

}


