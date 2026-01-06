class Food {
  final String id;
  final String name;
  final int caloriesPer100g;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final String region; // NG, global, etc

  Food({
    required this.id,
    required this.name,
    required this.caloriesPer100g,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.region,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    caloriesPer100g: json['caloriesPer100g'] ?? 0,
    proteinG: (json['proteinG'] as num).toDouble(),
    carbsG: (json['carbsG'] as num).toDouble(),
    fatG: (json['fatG'] as num).toDouble(),
    region: json['region'] ?? 'global',
  );
}
