// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: json['userId'] as String,
      organizationId: json['organizationId'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      orgType: json['orgType'] as String,
      blockchainIdentity: json['blockchainIdentity'] as String?,
      phone: json['phone'] as String?,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      location: json['location'] as String?,
      lastLogin: json['lastLogin'] == null
          ? null
          : DateTime.parse(json['lastLogin'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'organizationId': instance.organizationId,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'orgType': instance.orgType,
      'blockchainIdentity': instance.blockchainIdentity,
      'phone': instance.phone,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'location': instance.location,
      'lastLogin': instance.lastLogin?.toIso8601String(),
    };
