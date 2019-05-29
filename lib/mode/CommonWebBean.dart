import 'package:json_annotation/json_annotation.dart';

part 'CommonWebBean.g.dart';


@JsonSerializable()
class CommonWebBean {

  @JsonKey(name: 'data')
  List<Data> data;

  @JsonKey(name: 'errorCode')
  int errorCode;

  @JsonKey(name: 'errorMsg')
  String errorMsg;

  CommonWebBean(this.data,this.errorCode,this.errorMsg,);

  factory CommonWebBean.fromJson(Map<String, dynamic> srcJson) => _$CommonWebBeanFromJson(srcJson);

}


@JsonSerializable()
class Data {

  @JsonKey(name: 'icon')
  String icon;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'link')
  String link;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'order')
  int order;

  @JsonKey(name: 'visible')
  int visible;

  Data(this.icon,this.id,this.link,this.name,this.order,this.visible,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

}


