import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

class MyCalculator extends StatefulWidget {
  const MyCalculator({super.key});

  @override
  State<MyCalculator> createState() => _MyCalculatorState();
}

class _MyCalculatorState extends State<MyCalculator> {
  final _strBuffer = StringBuffer();
  var result = '0';
  double? hasilHitung = 0.0;
  var controller = TextEditingController();
  var buttonList = [
    'AC',
    'Akar',
    '^2',
    '/',
    '7',
    '8',
    '9',
    '*',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '00',
    '0',
    'delete',
    '='
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Calculator')),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    result,
                    style: const TextStyle(fontSize: 32, color: Colors.black),
                  ),
                  Visibility(
                      visible: hasilHitung != null,
                      child: Text('${hasilHitung ?? ''}'))
                ],
              ),
            ),
          )),
          Expanded(
              flex: 2,
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: buttonList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0),
                itemBuilder: (context, index) {
                  var operator = buttonList[index];

                  return InkWell(
                    onTap: () {
                      handleButton(operator);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 16,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ]),
                        child: Center(
                            child: operator == 'delete'
                                ? const Icon(Icons.backspace_outlined)
                                : Text(
                                    operator,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ))),
                  );
                },
              )),
        ],
      )),
    );
  }

  void handleButton(String operator) {
    if (hasilHitung != 0.0) {
      clearField();
      if (isDigit(operator)) {
        addChar(operator);
      }
    } else {
      switch (operator) {
        case 'AC':
          clearField();
          break;
        case 'Akar':
          handleAkar();
          break;
        case '^2':
          handleKuadrat();
          break;
        case 'delete':
          delChar();
          break;
        case '=':
          evalExpression();
          break;
        default:
          addChar(operator);
          break;
      }
    }
  }

  void addChar(String operator) {
    setState(() {
      _strBuffer.write(operator);
      result = _strBuffer.toString().trim();
      controller.text = result;
    });
  }

  void delChar() {
    if (_strBuffer.isNotEmpty) {
      setState(() {
        _strBuffer.clear();
        result =
            controller.text.substring(0, controller.text.length - 1).trim();
        _strBuffer.write(result);
        controller.text = result;

        if (result.isEmpty) {
          hasilHitung = 0.0;
        }
      });
    }
  }

  void clearField() {
    setState(() {
      _strBuffer.clear();
      controller.clear();
      result = '0';
      hasilHitung = 0.0;
    });
  }

  void handleAkar() {
    if (result.length > 1 &&
        (result.contains('+') ||
            result.contains('-') ||
            result.contains('*') ||
            result.contains('/'))) {
      showSnackbar('Saat ini baru bisa handle operasi akar untuk 1 buah nilai');
      return;
    }

    double pNumber = double.tryParse(result) ?? 0;
    var akar = sqrt(pNumber);
    setState(() {
      hasilHitung = akar;
    });
  }

  void handleKuadrat() {
    if (result.length > 1 &&
        (result.contains('+') ||
            result.contains('-') ||
            result.contains('*') ||
            result.contains('/'))) {
      showSnackbar(
          'Saat ini baru bisa handle operasi kuadrat untuk 1 buah nilai');
      return;
    }

    double pNumber = double.tryParse(result) ?? 0;
    var kuadrat = pow(pNumber, 2);
    setState(() {
      hasilHitung = kuadrat.toDouble();
    });
  }

  //memakai logic stack
  void evalExpression() {
    try {
      var evalResult = evalPostfix(infixToPostfix(result));
      setState(() {
        hasilHitung = evalResult;
      });
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }
  }

  //convert bentuk infix ke postfix (RPN)
  List<String> infixToPostfix(String expression) {
    var precedence = {
      '+': 1,
      '-': 1,
      '*': 2,
      '/': 2,
    };

    List<String> result = [];
    Queue<String> stack = Queue<String>();
    var i = 0;

    while (i < expression.length) {
      var c = expression[i];
      print("CHAR=$c");

      // jika karakter adalah operand, masukkan ke output/result
      if (isDigit(c)) {
        var numBuff = StringBuffer();

        while (i < expression.length && isDigit(expression[i])) {
          numBuff.write(expression[i]);
          i++;
        }

        result.add(numBuff.toString());
        continue; // continue untuk mencegah i ter-increment lagi
      }
      // jika karakter adalah operator
      else if (precedence.keys.contains(c)) {
        while (stack.isNotEmpty && precedence[stack.first]! >= precedence[c]!) {
          result.add(stack.removeFirst());
        }

        stack.addFirst(c);
      }

      i++;
    }

    // pop semua operator dari stack
    while (stack.isNotEmpty) {
      result.add(stack.removeFirst());
    }

    print("POST FIX = $result");

    return result;
  }

  // melakukan perhitungan, dengan logic stack
  double evalPostfix(List<String> postfix) {
    var stack = [];
    var operand = ['+', '-', '*', '/'];

    for (var token in postfix) {
      print('TOKEN=$token');
      if (double.tryParse(token) != null) {
        stack.add(double.parse(token));
      } else if (operand.contains(token)) {
        var b = stack.removeLast();
        var a = stack.removeLast();
        var result = 0.0;

        switch (token) {
          case '+':
            result = a + b;
            break;
          case '-':
            result = a - b;
            break;
          case '*':
            result = a * b;
            break;
          case '/':
            result = a / b;
            break;
          default:
            break;
        }

        print("RESULT=$result");
        stack.add(result);
      }
    }

    return stack.last;
  }

  bool isDigit(String s) {
    if (s.isEmpty || s.length > 1) {
      return false;
    }

    return RegExp(r'^\d$').hasMatch(s);
  }

  void showSnackbar(msg) {
    final sb = SnackBar(content: Text(msg));

    ScaffoldMessenger.of(context).showSnackBar(sb);
  }
}
