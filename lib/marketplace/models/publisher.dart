import 'dart:convert';

class Publisher {
  Publisher._({
    this.displayName,
    this.userName,
    this.hasAvatar,
    this.avatarUrl,
    this.gender,
  });

  final String? displayName;
  final String? userName;
  final bool? hasAvatar;
  final String? avatarUrl;
  final String? gender;

  Publisher copyWith({
    String? displayName,
    String? userName,
    bool? hasAvatar,
    String? avatarUrl,
    String? gender,
  }) =>
      Publisher._(
        displayName: displayName ?? this.displayName,
        userName: userName ?? this.userName,
        hasAvatar: hasAvatar ?? this.hasAvatar,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        gender: gender ?? this.gender,
      );

  factory Publisher.fromJson(String str) => Publisher.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Publisher.fromMap(Map<dynamic, dynamic> json) => Publisher._(
        displayName: json["displayName"],
        userName: json["userName"],
        hasAvatar: json["hasAvatar"],
        avatarUrl: json["avatarUrl"],
        gender: json["gender"],
      );

  Map<String, dynamic> toMap() => {
        "displayName": displayName,
        "userName": userName,
        "hasAvatar": hasAvatar,
        "avatarUrl": avatarUrl,
        "gender": gender,
      };
}
