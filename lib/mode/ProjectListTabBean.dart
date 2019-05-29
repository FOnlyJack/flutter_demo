import 'package:json_annotation/json_annotation.dart';

part 'ProjectListTabBean.g.dart';


@JsonSerializable()
class ProjectListTabBean {

  @JsonKey(name: 'data')
  List<ProjectListTabData> data;

  @JsonKey(name: 'errorCode')
  int errorCode;

  @JsonKey(name: 'errorMsg')
  String errorMsg;

  ProjectListTabBean(this.data,this.errorCode,this.errorMsg,);

  factory ProjectListTabBean.fromJson(Map<String, dynamic> srcJson) => _$ProjectListTabBeanFromJson(srcJson);

}


@JsonSerializable()
class ProjectListTabData {

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

  ProjectListTabData(this.children,this.courseId,this.id,this.name,this.order,this.parentChapterId,this.userControlSetTop,this.visible,);

  factory ProjectListTabData.fromJson(Map<String, dynamic> srcJson) => _$ProjectListTabDataFromJson(srcJson);

}


