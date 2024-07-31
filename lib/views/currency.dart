import 'package:flutter/material.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final rpController = TextEditingController();
  final dollarController = TextEditingController(text: '0');

  void reset() {
    setState(() {
      rpController.clear();
      dollarController.clear();
    });
  }

  void exchange() {
    var rp = rpController.text;

    var us = 16304.15;

    var convert = (double.tryParse(rp) ?? 0) / us;

    setState(() {
      dollarController.text = convert.toStringAsFixed(4);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Currency')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const Text(
                    'Rupiah',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    controller: rpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        hintText: 'Enter in Rupiah',
                        border: OutlineInputBorder(),
                        isDense: true),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  const Center(
                    child: Icon(Icons.currency_exchange),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  const Text(
                    'US Dollar',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    controller: dollarController,
                    canRequestFocus: false,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), isDense: true),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Text(
                    'Last updated: 7/26/2024, 23.58 UTC',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                Expanded(
                    child: OutlinedButton(
                  onPressed: () {
                    reset();
                  },
                  child: const Text('Reset'),
                )),
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    exchange();
                  },
                  child: const Text('Exchange'),
                )),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
