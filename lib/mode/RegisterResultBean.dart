import 'package:json_annotation/json_annotation.dart';

part 'RegisterResultBean.g.dart';


@JsonSerializable()
class RegisterResultBean{

  @JsonKey(name: 'data')
  Data data;
  @JsonKey(name: 'errorCode')
  int errorCode;

  @JsonKey(name: 'errorMsg')
  String errorMsg;

  RegisterResultBean(this.errorCode,this.errorMsg,);

  factory RegisterResultBean.fromJson(Map<String, dynamic> srcJson) => _$RegisterResultBeanFromJson(srcJson);
}
@JsonSerializable()
class Data {

  @JsonKey(name: 'admin')
  bool admin;

  @JsonKey(name: 'chapterTops')
  List<dynamic> chapterTops;

  @JsonKey(name: 'collectIds')
  List<dynamic> collectIds;

  @JsonKey(name: 'email')
  String email;

  @JsonKey(name: 'icon')
  String icon;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'password')
  String password;

  @JsonKey(name: 'token')
  String token;

  @JsonKey(name: 'type')
  int type;

  @JsonKey(name: 'username')
  String username;

  Data(this.admin,this.chapterTops,this.collectIds,this.email,this.icon,this.id,this.password,this.token,this.type,this.username,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

}