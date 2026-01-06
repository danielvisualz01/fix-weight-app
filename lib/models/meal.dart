class Meal {
  final String id;
  final String userId;
  final String foodId;
  final String foodName;
  final double quantity; // in grams or ml
  final String unit; // g, ml, cup, piece
  final String mealType; // breakfast, lunch, dinner, snack
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final DateTime loggedAt;
  final DateTime createdAt;

  Meal({
    required this.id,
    required this.userId,
    required this.foodId,
    required this.foodName,
    required this.quantity,
    required this.unit,
    required this.mealType,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.loggedAt,
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'userId': userId,
    'foodId': foodId,
    'foodName': foodName,
    'quantity': quantity,
    'unit': unit,
    'mealType': mealType,
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
    'loggedAt': loggedAt.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory Meal.fromFirestore(Map<String, dynamic> data) => Meal(
    id: data['id'] ?? '',
    userId: data['userId'] ?? '',
    foodId: data['foodId'] ?? '',
    foodName: data['foodName'] ?? '',
    quantity: (data['quantity'] as num).toDouble(),
    unit: data['unit'] ?? 'g',
    mealType: data['mealType'] ?? 'snack',
    calories: data['calories'] ?? 0,
    protein: (data['protein'] as num).toDouble(),
    carbs: (data['carbs'] as num).toDouble(),
    fat: (data['fat'] as num).toDouble(),
    loggedAt: DateTime.parse(data['loggedAt'] as String),
    createdAt: DateTime.parse(data['createdAt'] as String),
  );
}
