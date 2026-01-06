class User {
  final String uid;
  final String email;
  final String name;
  final double weightKg;
  final double heightCm;
  final int age;
  final String activityLevel; // sedentary, light, moderate, active
  final int dailyCaloricGoal;
  final DateTime createdAt;

  User({
    required this.uid,
    required this.email,
    required this.name,
    required this.weightKg,
    required this.heightCm,
    required this.age,
    required this.activityLevel,
    required this.dailyCaloricGoal,
    required this.createdAt,
  });

  // Calculate TDEE (Total Daily Energy Expenditure)
  static int calculateTDEE(double weightKg, double heightCm, int age, String activityLevel) {
    // Mifflin-St Jeor formula (male baseline, can adjust for gender)
    double bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;

    double multiplier = {
      'sedentary': 1.2,
      'light': 1.375,
      'moderate': 1.55,
      'active': 1.725,
    }[activityLevel] ?? 1.55;

    return (bmr * multiplier).toInt();
  }

  Map<String, dynamic> toFirestore() => {
    'uid': uid,
    'email': email,
    'name': name,
    'weightKg': weightKg,
    'heightCm': heightCm,
    'age': age,
    'activityLevel': activityLevel,
    'dailyCaloricGoal': dailyCaloricGoal,
    'createdAt': createdAt.toIso8601String(),
  };

  factory User.fromFirestore(Map<String, dynamic> data) => User(
    uid: data['uid'] ?? '',
    email: data['email'] ?? '',
    name: data['name'] ?? '',
    weightKg: (data['weightKg'] as num).toDouble(),
    heightCm: (data['heightCm'] as num).toDouble(),
    age: data['age'] ?? 0,
    activityLevel: data['activityLevel'] ?? 'moderate',
    dailyCaloricGoal: data['dailyCaloricGoal'] ?? 2000,
    createdAt: DateTime.parse(data['createdAt'] as String),
  );
}
