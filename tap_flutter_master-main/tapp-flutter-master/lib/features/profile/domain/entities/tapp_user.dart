import 'dart:core';
import 'package:equatable/equatable.dart';

/// User entity, used in domain and presentation layers
class TappUser extends Equatable {
  final String? uid;
  final String? name;
  final String? lastname;
  final String? username;
  final String? email;
  final String? description;
  final ProfilePicture? profilePicture;
  final String? phone;
  final int? birthday;
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

  const TappUser(
      {this.uid,
      this.name,
      this.lastname,
      this.username,
      this.email,
      this.description,
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
      this.followers});

  TappUser copyWith({
    String? name,
    String? username,
    String? lastname,
    String? email,
    String? description,
    ProfilePicture? profilePicture,
    String? phone,
    bool? verified,
    int? birthday,
    String? relationship,
    String? language,
    String? hobby,
    String? preference,
    String? ocupation,
    String? gender,
    String? messagingToken,
    bool? isProfilePictureEnabled,
    bool? isRegionalAlly,
    int? followingCount,
    int? followerCount,
    List<String>? following,
    List<String>? followers,
  }) {
    return TappUser(
      uid: uid,
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
      username: username ?? this.username,
      email: email ?? this.email,
      description: description ?? this.description,
      profilePicture: profilePicture ?? this.profilePicture,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      maritalStatus: relationship ?? maritalStatus,
      language: language ?? this.language,
      hobby: hobby ?? this.hobby,
      sexualPreference: preference ?? sexualPreference,
      occupation: ocupation ?? occupation,
      gender: gender ?? this.gender,
      messagingToken: messagingToken ?? this.messagingToken,
      verified: verified ?? this.verified,
      isProfilePictureEnabled:
          isProfilePictureEnabled ?? this.isProfilePictureEnabled,
      isRegionalAlly: isRegionalAlly ?? this.isRegionalAlly,
      followingCount: followingCount ?? this.followingCount,
      followerCount: followerCount ?? this.followerCount,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }

  factory TappUser.fromJson(Map<String, dynamic> json) {
    return TappUser(
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
      birthday: json['birthday'] ?? DateTime.now().millisecondsSinceEpoch,
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
      'followingCount': followingCount,
      'followerCount': followerCount,
      'following': following,
      'followers': followers,
    };
  }

  @override
  List<Object?> get props => [
        uid,
        name,
        lastname,
        username,
        email,
        description,
        profilePicture,
        phone,
        birthday,
        maritalStatus,
        language,
        hobby,
        verified,
        sexualPreference,
        occupation,
        gender,
        messagingToken,
        verified,
        isProfilePictureEnabled,
        isRegionalAlly,
        followingCount,
        followerCount,
        following,
        followers
      ];
}

class ProfilePicture {
  final String? url;
  final String? contentType;

  ProfilePicture({this.url, this.contentType});

  factory ProfilePicture.fromJson(Map<String, dynamic> json) {
    return ProfilePicture(
      url: json['url'] ?? '',
      contentType: json['contentType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url ?? '',
      'contentType': contentType ?? '',
    };
  }
}
