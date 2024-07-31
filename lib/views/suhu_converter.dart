import 'package:flutter/material.dart';

class SuhuScreen extends StatefulWidget {
  const SuhuScreen({super.key});

  @override
  State<SuhuScreen> createState() => _SuhuScreenState();
}

class _SuhuScreenState extends State<SuhuScreen> {
  final controller = TextEditingController();
  String? selectedTemp;
  String result = '0';

  final tempList = ['Fahrenheit', 'Kelvin', 'Reamur'];

  void reset() {
    controller.clear();
    setState(() {
      result = '0';
    });
  }

  void convert() {
    if (selectedTemp == null || controller.text.isEmpty) {
      return;
    }

    var c = double.tryParse(controller.text) ?? 0.0;

    if (selectedTemp! == 'Fahrenheit') {
      var f = (c * (9 / 5)) + 32;
      setState(() {
        result = '${f.toStringAsFixed(2)}°F';
      });
    } else if (selectedTemp! == 'Kelvin') {
      var k = c + 273.15;
      setState(() {
        result = '${k.toStringAsFixed(2)}K';
      });
    } else if (selectedTemp! == 'Reamur') {
      var r = c * (4 / 5);
      setState(() {
        result = '${r.toStringAsFixed(2)}°Ré';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Temperature')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        hintText: 'Enter in Celcius',
                        border: OutlineInputBorder(),
                        isDense: true),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  const Center(
                    child: Icon(Icons.sync),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: DropdownButtonFormField(
                          value: selectedTemp,
                          decoration: const InputDecoration(
                              labelText: 'Pick Conversion',
                              border: OutlineInputBorder()),
                          items: tempList.map((e) {
                            return DropdownMenuItem(value: e, child: Text(e));
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedTemp = value;
                            });
                          },
                        ),
                      ),
                    ],
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
                      result,
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
                    convert();
                  },
                  child: const Text('Convert'),
                )),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
