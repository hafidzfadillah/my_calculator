import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({super.key});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  final rpController = TextEditingController();
  final discountController = TextEditingController();
  String result = '0';

  void reset() {
    rpController.clear();
    discountController.clear();

    setState(() {
      result = '0';
    });
  }

  void calculate() {
    if (rpController.text.isEmpty || discountController.text.isEmpty) {
      return;
    }

    var rp = double.tryParse(rpController.text) ?? 0;
    var discount = double.tryParse(discountController.text) ?? 0;
    var cDiscount = discount / 100;

    var total = rp - (rp * cDiscount);

    setState(() {
      result = total.toStringAsFixed(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discount')),
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
                        hintText: 'Enter Total Price',
                        border: OutlineInputBorder(),
                        isDense: true),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  const Text(
                    '% Discount',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    controller: discountController,
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), isDense: true),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  const Center(child: Text('Result')),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Center(
                    child: Text(
                      NumberFormat.currency(symbol: 'Rp ', decimalDigits: 0)
                          .format(double.tryParse(result) ?? 0),
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
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
                    calculate();
                  },
                  child: const Text('Calculate'),
                )),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
