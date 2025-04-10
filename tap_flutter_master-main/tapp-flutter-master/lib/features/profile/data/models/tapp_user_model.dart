// ignore_for_file: annotate_overrides, overridden_fields

import 'dart:core';

import 'package:tapp/core/helpers/date_helper.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';

class TappUserModel extends TappUser {
  final String? uid;
  final String? name;
  final String? lastname;
  final String? username;
  final String? email;
  final String? description;
  final ProfilePicture? profilePicture;
  final String? phone;
  int? birthday;
  final String? maritalStatus;
  final String? language;
  final String? hobby;
  final String? sexualPreference;
  final String? occupation;
  final String? gender;
  final String? messagingToken;
  final bool? verified;
  final bool? isProfilePictureEnabled;
  final bool? isRegionalAlly;
  final int? followingCount;
  final int? followerCount;
  final List<String>? following;
  final List<String>? followers;

  TappUserModel(
      {this.uid,
      this.name,
      this.lastname,
      this.description,
      this.username,
      this.email,
      this.profilePicture,
      this.phone,
      this.birthday,
      this.maritalStatus,
      this.language,
      this.hobby,
      this.sexualPreference,
      this.occupation,
      this.gender,
      this.messagingToken,
      this.verified,
      this.isProfilePictureEnabled,
      this.isRegionalAlly,
      this.followingCount,
      this.followerCount,
      this.following,
      this.followers})
      : super(
            uid: uid,
            name: name,
            lastname: lastname,
            username: username,
            email: email,
            description: description,
            profilePicture: profilePicture,
            phone: phone,
            birthday: birthday,
            maritalStatus: maritalStatus,
            language: language,
            hobby: hobby,
            sexualPreference: sexualPreference,
            occupation: occupation,
            gender: gender,
            messagingToken: messagingToken,
            verified: verified,
            isProfilePictureEnabled: isProfilePictureEnabled,
            isRegionalAlly: isRegionalAlly,
            followingCount: followingCount,
            followerCount: followerCount,
            following: following,
            followers: followers);

  factory TappUserModel.fromJson(Map<String, dynamic> json) {
    return TappUserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      lastname: json['lastName'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      description: json['description'] ?? '',
      profilePicture: json['profilePicture'] != null
          ? ProfilePicture.fromJson(json['profilePicture'])
          : ProfilePicture(),
      phone: json['phone'] ?? '',
      birthday: json['birthday'] == null
          ? DateTime.now().millisecondsSinceEpoch
          : json['birthday'].runtimeType == int
              ? json['birthday']
              : DateHelper.dateTimeToTimestamp(
                  DateTime.parse(json['birthday'].toString())),
      maritalStatus: json['maritalStatus'] ?? 'Otro',
      language: json['language'] ?? '',
      hobby: json['hobby'] ?? '',
      sexualPreference: json['sexualPreference'] ?? 'Otro',
      occupation: json['occupation'] ?? '',
      gender: json['gender'] ?? 'Otro',
      messagingToken: json['messagingToken'] ?? '',
      verified: json['verified'] ?? false,
      isProfilePictureEnabled: json['isProfilePictureEnabled'] ?? false,
      isRegionalAlly: json['isRegionalAlly'] ?? false,
      followingCount: json['followingCount'] ?? 0,
      followerCount: json['followerCount'] ?? 0,
      following: json['following'] ?? [],
      followers: json['followers'] ?? [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'lastName': lastname,
      'username': username,
      'email': email,
      'description': description,
      'profilePicture': profilePicture?.toJson(),
      'phone': phone,
      'birthday': birthday,
      'maritalStatus': maritalStatus,
      'language': language,
      'hobby': hobby,
      'sexualPreference': sexualPreference,
      'occupation': occupation,
      'gender': gender,
      'messagingToken': messagingToken,
      'verified': verified,
      'isProfilePictureEnabled': isProfilePictureEnabled,
      'isRegionalAlly': isRegionalAlly,
      'followingCount': followingCount ?? 0,
      'followerCount': followerCount ?? 0,
      'following': following != null ? following!.map((i) => i).toList() : [],
      'followers': followers != null ? followers!.map((i) => i).toList() : [],
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
