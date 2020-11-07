// To parse this JSON data, do
//
//     final verifyMobile = verifyMobileFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

VerifyMobile verifyMobileFromJson(String str) =>
    VerifyMobile.fromJson(json.decode(str));

String verifyMobileToJson(VerifyMobile data) => json.encode(data.toJson());

class VerifyMobile {
  VerifyMobile({
    @required this.success,
    @required this.message,
    @required this.code,
  });

  final bool success;
  final String message;
  final String code;

  factory VerifyMobile.fromJson(Map<String, dynamic> json) => VerifyMobile(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "code": code == null ? null : code,
      };
}
