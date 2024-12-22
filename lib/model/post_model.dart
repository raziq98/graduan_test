import 'package:intl/intl.dart';

class PostModel {
  final int id;
  final String title;
  final String createdAt;
  final String updatedAt;

  PostModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
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
