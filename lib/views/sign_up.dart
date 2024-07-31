import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hafidz_uts/session_manager.dart';
import 'package:hafidz_uts/views/main_dashboard.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final mName = TextEditingController();
  final mEmail = TextEditingController();
  final mPass = TextEditingController();
  var agreeToc = false, hidePassword = false;

  void handleSignup() async {
    if (mName.text.isEmpty) {
      EasyLoading.showToast('Name cannot be empty');
      return;
    }

    if (mEmail.text.isEmpty) {
      EasyLoading.showToast('Email cannot be empty');
      return;
    }

    if (mPass.text.isEmpty) {
      EasyLoading.showToast('Password cannot be empty');
      return;
    }

    if (!agreeToc) {
      EasyLoading.showInfo(
          'You have to agree to our Terms of Conditions and Privacy Policy');
      return;
    }

    EasyLoading.show();

    final name = mName.text;
    final email = mEmail.text;

    SessionManager.createLoginSession(name, email);

    await Future.delayed(const Duration(seconds: 2));
    EasyLoading.dismiss();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => MainDashboard()));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height * 0.3,
              width: width,
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/bg_signup.jpg',))
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create your account',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  const Text('Name'),
                  TextField(
                    controller: mName,
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: 'Enter your name'),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  const Text('Email'),
                  TextField(
                    controller: mEmail,
                    decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: 'Enter your email'),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  const Text('Password'),
                  TextField(
                    controller: mPass,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                        isDense: true,
                        border: const OutlineInputBorder(),
                        hintText: 'Enter password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                            icon: Icon(hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off))),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: agreeToc,
                        onChanged: (isAgree) {
                          setState(() {
                            agreeToc = isAgree ?? false;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                          child: RichText(
                              text: TextSpan(
                                  text: 'I have read and agree to the ',
                                  style: const TextStyle(color: Colors.black),
                                  children: [
                            TextSpan(
                                text: 'Terms of conditions',
                                style: const TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {}),
                            const TextSpan(
                              text: ' and ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                                text: 'Privacy Policy',
                                style: const TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {}),
                          ])))
                    ],
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  SizedBox(
                    width: width,
                    child: ElevatedButton(
                      onPressed: () {
                        handleSignup();
                      },
                      child: const Text('Create Account'),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
