import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fixweight_mvp/screens/auth/login.dart';
import 'package:fixweight_mvp/screens/home/dashboard.dart';
import 'package:fixweight_mvp/services/auth_service.dart';
import 'package:fixweight_mvp/services/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase init
  await Firebase.initializeApp();

  // Hive init
  await Hive.initFlutter();
  await Hive.openBox('app_settings');
  await Hive.openBox('meals');
  await Hive.openBox('weights');

  // RevenueCat init
  await Purchases.configure(
    PurchasesConfiguration('appl_REVENUECAT_API_KEY_HERE'),
  );

  runApp(const FixWeightApp());
}

class FixWeightApp extends StatelessWidget {
  const FixWeightApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => HiveService()),
      ],
      child: MaterialApp(
        title: 'FixWeight',
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, _) {
        return authService.isLoggedIn ? const Dashboard() : const LoginScreen();
      },
    );
  }
}
