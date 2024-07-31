import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hafidz_uts/session_manager.dart';
import 'package:hafidz_uts/views/main_dashboard.dart';
import 'package:hafidz_uts/views/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLogin = prefs.getBool(SessionManager.IS_LOGIN) ?? false;
  runApp(MyApp(
    isLogin: isLogin,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isLogin});
  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: isLogin ? MainDashboard() : const SignUpScreen(),
      builder: EasyLoading.init(),
    );
  }
}
