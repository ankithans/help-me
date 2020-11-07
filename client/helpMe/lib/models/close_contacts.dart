// To parse this JSON data, do
//
//     final closeContacts = closeContactsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CloseContacts closeContactsFromJson(String str) =>
    CloseContacts.fromJson(json.decode(str));

String closeContactsToJson(CloseContacts data) => json.encode(data.toJson());

class CloseContacts {
  CloseContacts({
    @required this.success,
    @required this.phoneNumbers,
  });

  final bool success;
  final List<int> phoneNumbers;

  factory CloseContacts.fromJson(Map<String, dynamic> json) => CloseContacts(
        success: json["success"] == null ? null : json["success"],
        phoneNumbers: json["phoneNumbers"] == null
            ? null
            : List<int>.from(json["phoneNumbers"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "phoneNumbers": phoneNumbers == null
            ? null
            : List<dynamic>.from(phoneNumbers.map((x) => x)),
      };
}
