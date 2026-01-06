class Weight {
  final String id;
  final String userId;
  final double weightKg;
  final DateTime loggedAt;
  final DateTime createdAt;

  Weight({
    required this.id,
    required this.userId,
    required this.weightKg,
    required this.loggedAt,
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'userId': userId,
    'weightKg': weightKg,
    'loggedAt': loggedAt.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory Weight.fromFirestore(Map<String, dynamic> data) => Weight(
    id: data['id'] ?? '',
    userId: data['userId'] ?? '',
    weightKg: (data['weightKg'] as num).toDouble(),
    loggedAt: DateTime.parse(data['loggedAt'] as String),
    createdAt: DateTime.parse(data['createdAt'] as String),
  );
}
