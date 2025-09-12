import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String userId;
  final String organizationId;
  final String email;
  final String firstName;
  final String lastName;
  final String orgType; // ✅ match backend field
  final String? blockchainIdentity;
  final String? phone;
  final bool isActive;
  final DateTime createdAt; // ✅ DateTime
  final DateTime updatedAt; // ✅ DateTime
  final double? latitude;
  final double? longitude;
  final String? location;
  final DateTime? lastLogin;

  User({
    required this.userId,
    required this.organizationId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.orgType,
    this.blockchainIdentity,
    this.phone,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.latitude,
    this.longitude,
    this.location,
    this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
