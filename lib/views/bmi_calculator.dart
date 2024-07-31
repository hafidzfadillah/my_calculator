import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:numberpicker/numberpicker.dart';

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  int? selectedGenderValue;
  num currentHeight = 0, currentWeight = 0;
  RulerPickerController? _rulerPickerController;

  List<RulerRange> ranges = const [
    RulerRange(begin: 0, end: 250, scale: 1),
  ];

  void calculateBMI() {
    if (currentHeight == 0 || currentWeight == 0) {
      return;
    }

    var height = currentHeight / 100;
    var bmi = currentWeight / (height * height);
    var code = "normal";

    if (bmi < 18.5) {
      code = "underweight";
    } else if (bmi >= 25 && bmi < 29.9) {
      code = 'overweight';
    } else if (bmi >= 30 && bmi < 34.9) {
      code = 'obesity_1';
    } else if (bmi >= 35 && bmi < 39.9) {
      code = 'obesity_2';
    } else if (bmi >= 40) {
      code = 'obesity_3';
    }

    showModalBottomSheet(
      context: context,
      enableDrag: true,
      isDismissible: true,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return BMIResult(
          result: bmi,
          resultCode: code,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _rulerPickerController = RulerPickerController(value: currentHeight);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text(
                  'Gender',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(children: [
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: selectedGenderValue != 1
                            ? null
                            : Border.all(color: Colors.blue, width: 2),
                        boxShadow: selectedGenderValue == 1
                            ? null
                            : [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 16,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ]),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedGenderValue = 1;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/boy.png',
                              width: width * 0.25,
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            const Text(
                              'Male',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: selectedGenderValue != 2
                            ? null
                            : Border.all(color: Colors.blue, width: 2),
                        boxShadow: selectedGenderValue == 2
                            ? null
                            : [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 16,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ]),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedGenderValue = 2;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/woman.png',
                              width: width * 0.25,
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            const Text(
                              'Female',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
                ]),
                const SizedBox(
                  height: 16.0,
                ),
                const Text(
                  'Height',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                RulerPicker(
                  controller: _rulerPickerController,
                  width: width,
                  height: height * 0.06,
                  ranges: ranges,
                  // rulerScaleTextStyle: TextStyle(color: Colors.black, fontSize: 24),
                  scaleLineStyleList: const [
                    ScaleLineStyle(
                        color: Colors.grey, width: 1.5, height: 30, scale: 0),
                    ScaleLineStyle(
                        color: Colors.grey, width: 1, height: 25, scale: 5),
                    ScaleLineStyle(
                        color: Colors.grey, width: 1, height: 15, scale: -1)
                  ],
                  onValueChanged: (value) {
                    setState(() {
                      currentHeight = value;
                    });
                  },
                  onBuildRulerScaleText: (index, rulerScaleValue) {
                    // return rulerScaleValue.toInt().toString();
                    return '';
                  },
                ),
                Center(
                  child: Text(
                    '${currentHeight.toInt()} cm',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                const Text(
                  'Weight',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                NumberPicker(
                    minValue: 0,
                    maxValue: 500,
                    value: currentWeight.toInt(),
                    axis: Axis.horizontal,
                    haptics: true,
                    itemWidth: 110,
                    selectedTextStyle:
                        const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textStyle: const TextStyle(fontSize: 16),
                    onChanged: (value) {
                      setState(() {
                        currentWeight = value;
                      });
                    }),
                const Center(
                  child: Icon(
                    Icons.navigation,
                    size: 32,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: width,
              child: ElevatedButton(
                  onPressed: () {
                    calculateBMI();
                  },
                  child: const Text('Calculate BMI')),
            ),
          )
        ],
      ),
    );
  }
}

class BMIResult extends StatelessWidget {
  BMIResult({super.key, required this.result, required this.resultCode});
  final double result;
  final String resultCode;

  final resultDesc = {
    'underweight':
        'You are considered underweight. This may indicate malnutrition, an eating disorder, or other health issues. It is important to consult with a healthcare provider to determine the cause and develop a plan to achieve a healthier weight.',
    'normal':
        'Your BMI falls within the normal weight range. This suggests that you are maintaining a healthy weight for your height. Continue to follow a balanced diet and regular physical activity to sustain your health.',
    'overweight':
        'You are considered overweight. This increases the risk of developing various health conditions, including heart disease, high blood pressure, and diabetes. Consider adopting a healthier lifestyle with balanced nutrition and regular exercise.',
    'obesity_1':
        'You are classified as obese (Class I). This level of obesity increases the risk of serious health issues, including cardiovascular diseases, diabetes, and joint problems. It is advisable to seek guidance from a healthcare provider to create a plan for weight management.',
    'obesity_2':
        'You are classified as obese (Class II). This significantly increases the risk of severe health problems. Professional medical advice is strongly recommended to develop a comprehensive approach to weight loss and improve overall health.',
    'obesity_3':
        'You are classified as extremely obese (Class III). This level of obesity is associated with a high risk of life-threatening conditions, such as heart disease, diabetes, and certain cancers. Immediate medical intervention is crucial to address these health risks and develop an effective weight management strategy.',
  };

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width,
      child: ListView(children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text('Your BMI is:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 8.0,
                ),
                Text(result.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.headlineLarge),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              resultDesc[resultCode].toString(),
              maxLines: 10,
            ),
          ),
        )
      ]),
    );
  }
}
