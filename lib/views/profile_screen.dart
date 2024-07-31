import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hafidz_uts/session_manager.dart';
import 'package:hafidz_uts/views/sign_up.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final mName = TextEditingController();
  final mEmail = TextEditingController();
  final mDob = TextEditingController();
  var isMale = false;
  DateTime? dob;
  var isEdit = false;

  void initData() async {
    var name = await SessionManager.getData(SessionManager.KEY_NAME);
    var email = await SessionManager.getData(SessionManager.KEY_EMAIL);
    var sDob = await SessionManager.getData(SessionManager.KEY_DOB);
    var mIsMale = await SessionManager.getDataBool(SessionManager.KEY_GENDER);

    var ddob = DateTime.tryParse(sDob) ?? DateTime.now();

    setState(() {
      mName.text = name;
      mEmail.text = email;
      mDob.text = sDob.isEmpty ? 'Pick date' : sDob;
      isMale = mIsMale;
      dob = ddob;
    });
  }

  void pickDate() async {
    var result = await showDatePicker(
        context: context,
        initialDate: dob ?? DateTime.now(),
        firstDate: DateTime(1945, 1, 1),
        lastDate: DateTime.now());

    if (result != null) {
      var sDob = DateFormat('yyyy-MM-dd').format(result);

      setState(() {
        dob = result;
        mDob.text = sDob;
      });
    }
  }

  void saveData() async {
    if (mName.text.isEmpty) {
      EasyLoading.showToast('Name cannot be empty');
      return;
    }
    if (mEmail.text.isEmpty) {
      EasyLoading.showToast('Email cannot be empty');
      return;
    }
    if (dob == null) {
      EasyLoading.showToast('Please pick date of birth');
      return;
    }

    EasyLoading.show();
    var name = mName.text;
    var email = mEmail.text;
    var sDob = DateFormat("yyyy-MM-dd").format(dob!);

    SessionManager.updateDataString(SessionManager.KEY_NAME, name);
    SessionManager.updateDataString(SessionManager.KEY_EMAIL, email);
    SessionManager.updateDataString(SessionManager.KEY_DOB, sDob);
    SessionManager.updateDataBool(SessionManager.KEY_GENDER, isMale);

    await Future.delayed(const Duration(seconds: 2));
    EasyLoading.dismiss();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Update success')));
    setState(() {
      isEdit = false;
    });
  }

  void handleLogout() async {
    var confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Sign Out',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          content: const Text(
            'Are you sure you want to sign out from this account?',
            maxLines: 2,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Yes',
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );

    if (confirm == null || confirm == false) {
      return;
    }

    EasyLoading.show();
    await SessionManager.clearSession();
    EasyLoading.dismiss();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SignUpScreen()),
        (route) => false);
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          isEdit
              ? TextButton.icon(
                  onPressed: () {
                    setState(() {
                      isEdit = false;
                    });
                  },
                  icon: const Icon(Icons.close, color: Colors.red),
                  label: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ))
              : TextButton.icon(
                  onPressed: () {
                    setState(() {
                      isEdit = true;
                    });
                  },
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  label: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.blueAccent),
                  ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const Text('Name'),
                  TextField(
                    controller: mName,
                    decoration: InputDecoration(
                        enabled: isEdit,
                        isDense: true,
                        border: const OutlineInputBorder(),
                        hintText: 'Enter your name'),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  const Text('Email'),
                  TextField(
                    controller: mEmail,
                    decoration: InputDecoration(
                        enabled: isEdit,
                        isDense: true,
                        border: const OutlineInputBorder(),
                        hintText: 'Enter your email'),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  const Text('Gender'),
                  IgnorePointer(
                    ignoring: !isEdit,
                    child: Row(
                      children: [
                        Expanded(
                            child: ListTile(
                          leading: Radio(
                            value: true,
                            groupValue: isMale,
                            onChanged: (value) {
                              setState(() {
                                isMale = value ?? false;
                              });
                            },
                          ),
                          title: const Text('Male'),
                        )),
                        Expanded(
                            child: ListTile(
                          leading: Radio(
                            value: false,
                            groupValue: isMale,
                            onChanged: (value) {
                              setState(() {
                                isMale = value ?? false;
                              });
                            },
                          ),
                          title: const Text('Female'),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  const Text('Date of Birth'),
                  TextField(
                    controller: mDob,
                    canRequestFocus: false,
                    decoration: InputDecoration(
                        enabled: isEdit,
                        isDense: true,
                        border: const OutlineInputBorder(),
                        hintText: 'Pick date',
                        suffixIcon: const Icon(Icons.calendar_month)),
                    onTap: () {
                      pickDate();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              width: width,
              child: isEdit
                  ? ElevatedButton(
                      onPressed: () {
                        saveData();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        handleLogout();
                      },
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
