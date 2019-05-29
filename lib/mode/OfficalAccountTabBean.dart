import 'package:json_annotation/json_annotation.dart';

part 'OfficalAccountTabBean.g.dart';


@JsonSerializable()
class OfficalAccountTabBean {

  @JsonKey(name: 'data')
  List<OfficalAccountTabData> data;

  @JsonKey(name: 'errorCode')
  int errorCode;

  @JsonKey(name: 'errorMsg')
  String errorMsg;

  OfficalAccountTabBean(this.data,this.errorCode,this.errorMsg,);

  factory OfficalAccountTabBean.fromJson(Map<String, dynamic> srcJson) => _$OfficalAccountTabBeanFromJson(srcJson);

}


@JsonSerializable()
class OfficalAccountTabData {

  @JsonKey(name: 'children')
  List<dynamic> children;

  @JsonKey(name: 'courseId')
  int courseId;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'order')
  int order;

  @JsonKey(name: 'parentChapterId')
  int parentChapterId;

  @JsonKey(name: 'userControlSetTop')
  bool userControlSetTop;

  @JsonKey(name: 'visible')
  int visible;

  OfficalAccountTabData(this.children,this.courseId,this.id,this.name,this.order,this.parentChapterId,this.userControlSetTop,this.visible,);

  factory OfficalAccountTabData.fromJson(Map<String, dynamic> srcJson) => _$OfficalAccountTabDataFromJson(srcJson);

}


