import 'package:json_annotation/json_annotation.dart';

part 'HotSearchBean.g.dart';


@JsonSerializable()
class HotSearchBean {

  @JsonKey(name: 'data')
  List<Data> data;

  @JsonKey(name: 'errorCode')
  int errorCode;

  @JsonKey(name: 'errorMsg')
  String errorMsg;

  HotSearchBean(this.data,this.errorCode,this.errorMsg,);

  factory HotSearchBean.fromJson(Map<String, dynamic> srcJson) => _$HotSearchBeanFromJson(srcJson);

}


@JsonSerializable()
class Data {

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

  Data(this.id,this.link,this.name,this.order,this.visible,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

}