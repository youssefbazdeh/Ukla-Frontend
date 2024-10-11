import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/features/body_needs_estimation/domain/entities/BodyInfo.dart';
import '../../../../core/Presentation/inputs/LittleInputField.dart';
import 'select_activity.dart';

class SelectHeightWeight extends StatefulWidget {
  const SelectHeightWeight({Key? key}) : super(key: key);

  @override
  State<SelectHeightWeight> createState() => _SelectHeightWeightState();
}

class _SelectHeightWeightState extends State<SelectHeightWeight> {
  BodyInfo bodyinfo = BodyInfo();
  var weightUnits = ["Kg", "Pound"];
  var heightUnits = ["Cm", "ft"];

  String? _currentSelectedweightValue = "Kg";
  String? _currentSelectedHeightValue = "Cm";
  int? age;

  String? sex;
  //String? sex = "Female";
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _heightInIchesController = TextEditingController();
  final _ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 0.03 * height,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: 10, right: width / 10, left: width / 10),
                    child: Text(
                      "Insert your body information".tr(context),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.secondaryColor,
                          letterSpacing: 0),
                    ),
                  ),
                  SizedBox(
                    height: 0.025 * height,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(right: width / 15, left: width / 15),
                    child: Container(
                        width: width,
                        height: portraintOrLandScape(height),
                        decoration: BoxDecoration(
                            color: AppColors.backgroundGrey,
                            borderRadius: BorderRadius.circular(26)),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: height / 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child:
                                    // select height field
                                    Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        LittleInputField(
                                            width: width / 3,
                                            labelText: "weight".tr(context),
                                            hintText: "weight".tr(context),
                                            textEditingController:
                                                _weightController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please insert your weight'
                                                    .tr(context);
                                              }
                                              try {
                                                double.parse(value);
                                              } catch (e) {
                                                return "Use numbers and . only"
                                                    .tr(context);
                                              }

                                              if (1 < double.parse(value) &&
                                                  double.parse(value) < 1000) {
                                                return null;
                                              } else {
                                                return 'Please insert a valid weight'
                                                    .tr(context);
                                              }
                                            }),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          children: [
                                            FormField<String>(
                                              builder: (FormFieldState<String>
                                                  state) {
                                                return SizedBox(
                                                  height: 75,
                                                  width: 100,
                                                  child: InputDecorator(
                                                    decoration: InputDecoration(
                                                        labelStyle:
                                                          TextStyle(
                                                                fontSize: 50.sp,
                                                                color: Colors
                                                                    .amberAccent),
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0))),
                                                    isEmpty:
                                                        _currentSelectedweightValue ==
                                                            '',
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                      child: DropdownButton<
                                                          String>(
                                                        isExpanded: true,
                                                        value:
                                                            _currentSelectedweightValue,
                                                        isDense: true,
                                                        onChanged:
                                                            (String? newValue) {
                                                          setState(() {
                                                            _currentSelectedweightValue =
                                                                newValue;
                                                            state.didChange(
                                                                newValue);
                                                          });
                                                        },
                                                        items: weightUnits.map(
                                                            (String value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: value,
                                                            child: Text(value),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height / 40,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(child: cmOrFeet(width)),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        FormField<String>(
                                          builder:
                                              (FormFieldState<String> state) {
                                            return SizedBox(
                                              height: 75,
                                              width: 100,
                                              child: InputDecorator(
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    8.0))),
                                                isEmpty:
                                                    _currentSelectedHeightValue ==
                                                        '',
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton<String>(
                                                    value:
                                                        _currentSelectedHeightValue,
                                                    isDense: true,
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        _currentSelectedHeightValue =
                                                            newValue;
                                                        state.didChange(
                                                            newValue);
                                                      });
                                                    },
                                                    items: heightUnits
                                                        .map((String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: height / 40,
                                          left: width / 9,
                                          right: width / 9,
                                          bottom: 0),
                                      child: DropdownButtonFormField<String>(
                                        decoration: const InputDecoration(
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)))),
                                        // Initial Value
                                        value: sex,

                                        isExpanded: true,

                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please insert your sex'
                                                .tr(context);
                                          }
                                          return null;
                                        },
                                        hint: Text("sex".tr(context)),
                                        items: [
                                          DropdownMenuItem(
                                            child: Text("Male".tr(context)),
                                            value: "Male",
                                          ),
                                          DropdownMenuItem(
                                            child: Text("Female".tr(context)),
                                            value: "Female",
                                          )
                                        ],
                                        onChanged: (String? value) {
                                          setState(() {
                                            sex = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: height / 25,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        LittleInputField(
                                            width: width / 3,
                                            labelText: "age".tr(context),
                                            hintText: "age".tr(context),
                                            textEditingController:
                                                _ageController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please insert your age'
                                                    .tr(context);
                                              }
                                              try {
                                                double.parse(value);
                                              } catch (e) {
                                                return "Use numbers and . only"
                                                    .tr(context);
                                              }
                                              if (0 < double.parse(value) &&
                                                  double.parse(value) < 200) {
                                                return null;
                                              } else {
                                                return 'Please insert a valid age';
                                              }
                                            }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                  SizedBox(
                    height: height / 25,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: width / 9, left: width / 9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0XFFFA6375),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              bodyinfo.age = int.tryParse(_ageController.text);
                              bodyinfo.weight = convertWeight();
                              bodyinfo.height = convertHeight();

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SelectActivity(
                                            sex: sex!,
                                            bodyInfo: bodyinfo,
                                          )));
                            }
                          },
                          child: Text(
                            "Next".tr(context),
                            style:  TextStyle(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  double portraintOrLandScape(double height) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return height * 0.6;
    } else {
      return height * 1.2;
    }
  }

  double? convertHeight() {
    if (_currentSelectedHeightValue == "Cm") {
      return double.tryParse(_heightController.text);
    }
    if (_currentSelectedHeightValue == "ft") {
      double heightOfFeet = double.parse(_heightController.text);
      double heightOfInches = double.parse(_heightInIchesController.text);
      return (heightOfFeet * 12 + heightOfInches) * 2.54;
    }
    return null;
  }

  double? convertWeight() {
    if (_currentSelectedweightValue == "Kg") {
      return double.tryParse(_weightController.text);
    }
    if (_currentSelectedweightValue == "Pound") {
      double wightInPounds = double.parse(_weightController.text);
      return wightInPounds * 0.453592;
    }
    return null;
  }

  Widget cmOrFeet(double width) {
    if (_currentSelectedHeightValue == "Cm") {
      return LittleInputField(
          width: width / 3,
          labelText: "height".tr(context),
          hintText: "height".tr(context),
          textEditingController: _heightController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please insert your height'.tr(context);
            }
            try {
              double.parse(value);
            } catch (e) {
              return "Use numbers and . only".tr(context);
            }
            if (1 < double.parse(value) && double.parse(value) < 300) {
              return null;
            } else {
              return 'Please insert a valid height'.tr(context);
            }
          });
    } else {
      return Row(
        children: [
          LittleInputField(
              labelText: "ft",
              hintText: "ft",
              textEditingController: _heightController,
              width: 80,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'insert your height'.tr(context);
                }
                try {
                  double.parse(value);
                } catch (e) {
                  return "Use numbers and . only".tr(context);
                }
                if (1 <= double.parse(value) && double.parse(value) < 10) {
                  return null;
                } else {
                  return 'insert a valid height'.tr(context);
                }
              }),
          const SizedBox(width: 15),
          LittleInputField(
              labelText: "inches",
              hintText: "inches",
              textEditingController: _heightInIchesController,
              width: 80,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'insert your height'.tr(context);
                }
                try {
                  double.parse(value);
                } catch (e) {
                  return "Use numbers and . only".tr(context);
                }
                if (double.parse(value) < 12) {
                  return null;
                } else {
                  return 'insert a valid height'.tr(context);
                }
              }),
        ],
      );
    }
  }
}
