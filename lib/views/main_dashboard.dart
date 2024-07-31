import 'package:flutter/material.dart';
import 'package:hafidz_uts/session_manager.dart';
import 'package:hafidz_uts/views/profile_screen.dart';
import 'package:hafidz_uts/views/suhu_converter.dart';

import 'bmi_calculator.dart';
import 'calculator.dart';
import 'currency.dart';
import 'discount.dart';

class MainDashboard extends StatelessWidget {
  MainDashboard({super.key});

  final menuList = [
    {
      'title': 'Basic Calculator',
      'image': 'calculator.png',
      'path': const MyCalculator()
    },
    {'title': 'BMI Calculator', 'image': 'bmi.png', 'path': const BMIScreen()},
    {
      'title': 'Currency',
      'image': 'exchange.png',
      'path': const CurrencyScreen()
    },
    {
      'title': 'Temperature',
      'image': 'temperature.png',
      'path': const SuhuScreen()
    },
    {
      'title': 'Discount',
      'image': 'discount.png',
      'path': const DiscountScreen()
    },
  ];

  Future<String> getName() async {
    final name = await SessionManager.getData(SessionManager.KEY_NAME);

    return name;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome,',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      FutureBuilder<String>(
                          future: getName(),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data ?? '-',
                              style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            );
                          }),
                    ],
                  )),
                  IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const ProfileScreen()));
                      },
                      icon: const Icon(Icons.account_circle,
                          size: 48, color: Colors.white)),
                ],
              ),
            ),
            Expanded(
                child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0))),
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0),
                itemCount: menuList.length,
                itemBuilder: (context, index) {
                  var item = menuList[index];

                  return Card(
                    child: InkWell(
                      onTap: () {
                        var page = item['path'] as Widget;

                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => page));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/${item['image']}',
                              width: width * 0.15,
                              height: width * 0.15,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              item['title'].toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              maxLines: 2,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ))
          ],
        ),
      ),
    );
  }
}
