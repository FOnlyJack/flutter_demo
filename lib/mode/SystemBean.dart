import 'package:json_annotation/json_annotation.dart';

part 'SystemBean.g.dart';


@JsonSerializable()
class SystemBean {

  @JsonKey(name: 'data')
  List<SystemBeanChild> data;

  @JsonKey(name: 'errorCode')
  int errorCode;

  @JsonKey(name: 'errorMsg')
  String errorMsg;

  SystemBean(this.data,this.errorCode,this.errorMsg,);

  factory SystemBean.fromJson(Map<String, dynamic> srcJson) => _$SystemBeanFromJson(srcJson);
  Map<String, dynamic> toJson() => _$SystemBeanToJson(this);
}


@JsonSerializable()
class SystemBeanChild {

  @JsonKey(name: 'children')
  List<Children> children;

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

  SystemBeanChild(this.children,this.courseId,this.id,this.name,this.order,this.parentChapterId,this.userControlSetTop,this.visible,);

  factory SystemBeanChild.fromJson(Map<String, dynamic> srcJson) => _$SystemBeanChildFromJson(srcJson);
  Map<String, dynamic> toJson() => _$SystemBeanChildToJson(this);
}


@JsonSerializable()
class Children {

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

  Children(this.children,this.courseId,this.id,this.name,this.order,this.parentChapterId,this.userControlSetTop,this.visible,);

  factory Children.fromJson(Map<String, dynamic> srcJson) => _$ChildrenFromJson(srcJson);
  Map<String, dynamic> toJson() => _$ChildrenToJson(this);
}


