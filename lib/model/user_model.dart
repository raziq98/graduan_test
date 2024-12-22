import 'package:intl/intl.dart';

class UserData {
  final int id;
  final String name;
  final String email;
  final String emailVerifiedAt;
  final String createdAt;
  final String updatedAt;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: formatDate(json['email_verified_at']),
      createdAt: formatDate(json['created_at']),
      updatedAt: formatDate(json['updated_at']),
    );
  }

  static String formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);

    DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm");

    return dateFormat.format(dateTime);
  }
}