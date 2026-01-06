import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthService extends ChangeNotifier {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  User? get user => _user;
  bool get isLoggedIn => _auth.currentUser != null;
  String? get uid => _auth.currentUser?.uid;

  AuthService() {
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    _auth.authStateChanges().listen((fbUser) async {
      if (fbUser != null) {
        await _fetchUser(fbUser.uid);
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  Future<void> _fetchUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _user = User.fromFirestore(doc.data()!);
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  // Signup
  Future<bool> signup({
    required String email,
    required String password,
    required String name,
    required double weightKg,
    required double heightCm,
    required int age,
    required String activityLevel,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user!.uid;
      final dailyCaloricGoal = User.calculateTDEE(weightKg, heightCm, age, activityLevel);

      final newUser = User(
        uid: uid,
        email: email,
        name: name,
        weightKg: weightKg,
        heightCm: heightCm,
        age: age,
        activityLevel: activityLevel,
        dailyCaloricGoal: dailyCaloricGoal,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(uid).set(newUser.toFirestore());
      _user = newUser;
      notifyListeners();
      return true;
    } catch (e) {
      print('Signup error: $e');
      return false;
    }
  }

  // Login
  Future<bool> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  // Update user profile
  Future<bool> updateProfile({
    required double weightKg,
    required double heightCm,
    required int age,
    required String activityLevel,
  }) async {
    try {
      if (_user == null) return false;

      final dailyCaloricGoal = User.calculateTDEE(weightKg, heightCm, age, activityLevel);

      await _firestore.collection('users').doc(_user!.uid).update({
        'weightKg': weightKg,
        'heightCm': heightCm,
        'age': age,
        'activityLevel': activityLevel,
        'dailyCaloricGoal': dailyCaloricGoal,
      });

      _user = User(
        uid: _user!.uid,
        email: _user!.email,
        name: _user!.name,
        weightKg: weightKg,
        heightCm: heightCm,
        age: age,
        activityLevel: activityLevel,
        dailyCaloricGoal: dailyCaloricGoal,
        createdAt: _user!.createdAt,
      );
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
