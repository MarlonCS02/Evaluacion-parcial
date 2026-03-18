class Status {
  final int id;
  final int userId;
  final String statusName;
  final String color;

  Status({
    required this.id,
    required this.userId,
    required this.statusName,
    required this.color,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      statusName: json['status_name'] ?? '',
      color: json['color'] ?? '#4CAF50',
    );
  }
}