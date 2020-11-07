// To parse this JSON data, do
//
//     final register = registerFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Register registerFromJson(String str) => Register.fromJson(json.decode(str));

String registerToJson(Register data) => json.encode(data.toJson());

class Register {
  Register({
    @required this.success,
    @required this.token,
    @required this.userId,
  });

  final bool success;
  final String token;
  final String userId;

  factory Register.fromJson(Map<String, dynamic> json) => Register(
        success: json["success"] == null ? null : json["success"],
        token: json["token"] == null ? null : json["token"],
        userId: json["userId"] == null ? null : json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "token": token == null ? null : token,
        "userId": userId == null ? null : userId,
      };
}
