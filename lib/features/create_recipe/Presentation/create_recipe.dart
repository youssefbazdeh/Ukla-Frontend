// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ukla_app/Localizations/app_localizations.dart';


class CreateRecipe extends StatefulWidget {
  const CreateRecipe({Key? key}) : super(key: key);

  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

////////////////////////////////****************************************
///
///
///FL INTERFACE HETHI ZEDT FL SDKVERSION LEL 33 KHATR  9ALI LEZM ETALA3HA BSH L PACKAGE PERMISSION YMSHI
///
///
/// */

//////////////////////////////////////////////////////////nooooooooooooote
///
///
///
///
///ki fl list view tetzed item naaml setstate lel page kemla wla najm naaml lel list view bark (performance)

class _CreateRecipeState extends State<CreateRecipe> {
/////////////////////////image picker
  File? image;
  Future getImage(String pickfrom) async {
    ImageSource source;
    if (pickfrom == 'camera') {
      source = ImageSource.camera;
    } else {
      source = ImageSource.gallery;
    }
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) {
      return;
    }
    //get the image path
    setState(() {
      this.image = File(image.path);
    });
  }

  /////list des step
  List<Step> stepList = [Step(instruction: '', cookingTip: '')];
  /////list des ingredientsList
  List<IngredientInfo> ingredientsList = [
    IngredientInfo(
      ingredient: Ingredient(name: '', nbrCalories100gr: 0, type: ''),
      unit: '.kg',
      quantity: '0',
    ),
    IngredientInfo(
      ingredient: Ingredient(name: '', nbrCalories100gr: 0, type: ''),
      unit: '.kg',
      quantity: '0',
    ),
  ];
  ////ingredient 1&2 controller

  ///timer controller
  TextEditingController timer = TextEditingController();
  int calories = 0;
  int serving = 4;
  FocusNode timernode = FocusNode();
  TextEditingController recipeName = TextEditingController();
  bool checked = false;

  List<String> units = [".g", ".kg"];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double widht = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 40, left: 23, bottom: 8, right: 25),
              child: Row(
                children: [
                  Text('Create recipe'.tr(context),
                      style:  TextStyle(
                          fontSize: 24.sp, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          backgroundColor:
                              MaterialStateProperty.all(const Color(0xFFFA6375))),
                      onPressed: () async {
                        checked = !checked;
                        setState(() {});

                        if (checked == true) {
                       
                          var snackBar = SnackBar(
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(5),
                            backgroundColor: const Color(0XFFFA6375),
                            content: Text(
                              'recipe saved '.tr(context),
                              style: TextStyle(fontSize: 15.sp),
                              textAlign: TextAlign.center,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          //printit recipe saved
                        } else {
                          var snackBar2 = SnackBar(
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(5),
                            backgroundColor: const Color(0XFFFA6375),
                            content: Text(
                              'recipe unsaved '.tr(context),
                              style: TextStyle(fontSize: 15.sp),
                              textAlign: TextAlign.center,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                    
                        }


                      },
                      child: Row(
                        children: [
                          Text('Save'.tr(context),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.sp)),
                          const SizedBox(
                            width: 10,
                          ),
                          Icon(
                            !checked
                                ? Ionicons.checkmark_circle_outline
                                : Ionicons.checkmark_outline,
                            color: Colors.white,
                          )
                        ],
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            //////////////boxmodel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.shade300,
                child: InkWell(
                  onTap: () {
                    //////////////////////  /////^popupppppp
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: image == null ? 10 : 20),
                            child: SizedBox(
                              height: height / 8,
                              child: Column(
                                mainAxisAlignment: image != null
                                    ? MainAxisAlignment.spaceBetween
                                    : MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      var galleryStatus =
                                          await Permission.storage.request();
                             
                                      if (galleryStatus.isGranted) {
                                        getImage('gallery');
                                      } else if (galleryStatus.isDenied) {
                                      } else if (galleryStatus
                                          .isPermanentlyDenied) {
                                        openAppSettings();
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(Ionicons.image_outline),
                                        const SizedBox(width: 20),
                                        Text(
                                          'choose image from gallery'
                                              .tr(context),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      var cameraStatus =
                                          await Permission.camera.request();
                                      if (cameraStatus.isGranted) {
                                        getImage('camera');
                                      } else if (cameraStatus.isDenied) {                                
                                    
                                      } else if (cameraStatus
                                          .isPermanentlyDenied) {
                                        openAppSettings();
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(Ionicons.camera_outline),
                                        const SizedBox(width: 20),
                                        Text(
                                          'Take a photo'.tr(context),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                  ),
                                  image != null
                                      ? InkWell(
                                          onTap: () {
                                            setState(() {
                                              image = null;
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(
                                                  Ionicons.trash_outline),
                                              const SizedBox(width: 20),
                                              Text(
                                                'Delete image'.tr(context),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.sp,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )
                                            ],
                                          ))
                                      : const SizedBox(height: 0, width: 0),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      image: image != null
                          ? DecorationImage(
                              fit: BoxFit.cover, image: FileImage(image!))
                          : null,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: 265,
                    child: image == null
                        ? Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                Icon(
                                  color: const Color.fromARGB(234, 255, 255, 255),
                                  Ionicons.image,
                                  size: height / 5,
                                ),
                                Text(
                                  'Choose image '.tr(context),
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 133, 133, 133),
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ]))
                        : Container(
                            color: Colors.white.withOpacity(0),
                          ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            ////a revoir

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: recipeName,
                // textAlign: TextAlign.center,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    hintText: 'Recipe name'.tr(context)),
              ),
            ),
            const SizedBox(height: 15),
            //type diet category
            Padding(
              padding: const EdgeInsets.only(left: 29),
              child: Row(
                children: [
                  InkWell(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(6),
                          //  color: Colors.black
                        ),
                        child: Text('Type'.tr(context),
                            style: TextStyle(
                                fontSize: 14.sp, color: const Color(0xFF8A8A8A)))),
                  ),
                  const SizedBox(width: 13),
                  InkWell(
                    child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 201, 201, 201),
                          borderRadius: BorderRadius.circular(6),
                          //  color: Colors.black
                        ),
                        child: Text('Category'.tr(context),
                            style:  TextStyle(fontSize: 14.sp))),
                  ),
                  const SizedBox(width: 13),
                  InkWell(
                    child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 201, 201, 201),
                          borderRadius: BorderRadius.circular(6),
                          //  color: Colors.black
                        ),
                        child: Text('Diet'.tr(context),
                            style: TextStyle(fontSize: 14.sp))),
                  ),
                  const SizedBox(width: 13),

                  const SizedBox(
                    height: 13,
                  ),
                  //////calories + timer
                ],
              ),
            ),
            const SizedBox(height: 13),
            //calories + timer
            Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Row(children: [
                  //Timer
                  InkWell(
                    onTap: () {
                      FocusScope.of(context).requestFocus(timernode);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 8),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(3)),
                      child: Row(
                        children: [
                          const Icon(Ionicons.time_outline),
                          const SizedBox(width: 5),
                          ///////////////////////////a revoir ylzsh tekhdm bl set state    njrb provier
                          SizedBox(
                            height: 0,
                            width: 0,
                            child: TextField(
                                onChanged: (value) {
                                  setState(() {});
                                },
                                showCursor: false,
                                //maxLength: 3,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(3)
                                ],
                                focusNode: timernode,
                                controller: timer,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  focusedBorder: InputBorder.none,
                                  hintText: '0',
                                  //labelText: 'insert your step here',
                                )),
                          ),
                          Text(
                            timer.text.isEmpty ? '0 m' : '${timer.text} m',
                            style: TextStyle(fontSize: 16.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 58),
                  //Calories
                  const Icon(Ionicons.fast_food),
                  const SizedBox(width: 5),
                  Text(
                    "$calories " "Cal".tr(context),
                    style:  TextStyle(fontSize: 16.sp),
                  )
                ]),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            //barre taa servings
            Padding(
              padding: const EdgeInsets.only(left: 19, right: 9),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$serving ' 'Servings'.tr(context),
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    const SizedBox(
                      width: 26,
                    ),
                    const Icon(
                      Ionicons.people_outline,
                      size: 25,
                    ),
                    //  const SizedBox(width: 110),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        if (serving > 1) serving--;
                        setState(() {});
                      },
                      child:  Text(
                        '-',
                        style: TextStyle(fontSize: 30.sp),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Text(
                      '$serving',
                      style:  TextStyle(fontSize: 16.sp),
                    ),
                    const SizedBox(width: 18),
                    InkWell(
                      child:  Text(
                        '+',
                        style: TextStyle(fontSize: 30.sp),
                      ),
                      onTap: () {
                        serving++;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
            //title Ingredieents
            const SizedBox(
              height: 8,
            ),
            Container(
              child: Text('Ingredients'.tr(context),
                  style:  TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Noto_Sans',
                  )),
              padding: const EdgeInsets.symmetric(vertical: 10),
              margin: const EdgeInsets.only(left: 25),
            ),

            const SizedBox(height: 8),
            //////listview

            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: ingredientsList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 40, right: 0),
                  child: Row(
                    children: [
                      const Icon(
                        Ionicons.fast_food,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Ingredient'.tr(context) + ' ${index + 1}',
                        style:  TextStyle(fontSize: 16.sp),
                      ),
                      const Spacer(),

                      //////quantity
                      SizedBox(
                          //  color: Colors.black,
                          width: 45,
                          child: TextField(
                              controller: TextEditingController(
                                text: ingredientsList[index].quantity == '0'
                                    ? ''
                                    : ingredientsList[index].quantity,
                              ),
                              onChanged: (value) {
                                ingredientsList[index].quantity = value;
                              },
                              onEditingComplete: () {
                                if (ingredientsList[index].quantity == '') {
                                  ingredientsList[index].quantity = '0';
                                }
                                FocusScope.of(context).unfocus();
                              },
                              //   controller: ingredient1controller,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(3),
                              ],
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(right: 15),
                                border: InputBorder.none,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                focusedBorder: InputBorder.none,
                                hintText: 'QT',
                              ))),
                      SizedBox(
                        width: 50,
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none),
                          value: ingredientsList[index].unit,
                          items: units.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? val) {
                            ingredientsList[index].unit = val!;
                            setState(() {});
                          },
                          //    icon: const Icon(Icons.keyboard_arrow_down)
                        ),
                      ),

                      Visibility(
                        maintainAnimation: true,
                        maintainSize: true,
                        maintainState: true,
                        maintainSemantics: true,
                        visible: index < 2 ? false : true,
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            setState(() {
                              ingredientsList.removeAt(index);
                            });
                          },
                          icon: const Icon(Ionicons.close),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      ingredientsList.add(IngredientInfo(
                        ingredient:
                            Ingredient(name: '', nbrCalories100gr: 0, type: ''),
                        unit: '.kg',
                        quantity: '0',
                      ));
                    });
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Ionicons.add_circle,
                        size: 30,
                        color: Color(0xFFA6A6A6),
                      ),
                      const SizedBox(
                        width: 32,
                      ),
                      Text(
                        'Add Ingredient'.tr(context),
                        style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                            fontFamily: 'Noto_Sans',
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  )),
            ),

            const SizedBox(
              height: 8,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 25, right: 20),
              child: Row(
                children: [
                  Text('Directions'.tr(context),
                      style:  TextStyle(
                          fontFamily: 'Noto_Sans',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold)),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      stepList.add(Step(instruction: '', cookingTip: ''));
                      setState(() {});
                     
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFFA6375),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('Add step'.tr(context),
                          style:  TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontFamily: 'Noto_Sans',
                          )),
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 10),
                    ),
                  ),
                ],
              ),
            ),

            ///steps text  field

            //////////////////////////////////step container
            const SizedBox(height: 18),

            //b9eyet l steps
            ListView.builder(
              itemCount: stepList.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  padding: const EdgeInsets.only(top: 10, left: 32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: const Color(0x80F6F6F6),
                  ),
                  child: Column(
                    children: [
                      Row(children: [
                        //////circle
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black)),
                        ),

                        const SizedBox(width: 15),

                        Text(
                          'Step'.tr(context) + ' ${index + 1}',
                          style:  TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Noto_Sans',
                            fontSize: 17.sp,
                          ),
                        ),

                        const Spacer(),

                        Visibility(
                          maintainAnimation: true,
                          maintainSize: true,
                          maintainState: true,
                          maintainSemantics: true,
                          visible: index == 0 ? false : true,
                          child: IconButton(
                            onPressed: () {
                              setState(() {});
                              stepList.removeAt(index);
                            },
                            icon: const Icon(Ionicons.close),
                            padding: const EdgeInsets.only(right: 5),
                          ),
                        ),
                      ]),
                      TextField(
                          //focusNode: FocusNode(),
                          controller: TextEditingController(
                              text: stepList[index].instruction),
                          onChanged: ((value) =>
                              {stepList[index].instruction = value}),
                          onEditingComplete: () {
                            FocusScope.of(context).nextFocus();
                          },
                          //cursorColor: Colors.amber,
                          textInputAction: TextInputAction.done,
                          maxLines: null,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            focusedBorder: InputBorder.none,
                            hintText: 'insert your step here'.tr(context),
                            //labelText: 'insert your step here',
                          )),
                    ],
                  ),
                );
              },
            ),
          ],

          /////ingredientsList
        )),
      ),
    );
  }
}

class IngredientInfo {
  Ingredient? ingredient;
  String? unit = '';
  String? quantity = '';

  IngredientInfo(
      {required this.unit, required this.quantity, required this.ingredient});
  @override
  String toString() {
    // TODO: implement toString
    return '{${ingredient.toString()} | unit : $unit| quantity $quantity  }\n';
  }
}

class Ingredient {
  String? name = '';
  String? type = "Autre";
  double? nbrCalories100gr = 0.0;

  Ingredient({this.type, this.nbrCalories100gr, this.name});
  @override
  String toString() {
    // TODO: implement toString
    return '{ name :$name,type :$type,nbrcalories :$nbrCalories100gr}';
  }
}

class Speciality {
  String? name;
  Speciality({this.name});
}

class Step {
  String instruction;
  String cookingTip;
  Step({required this.instruction, required this.cookingTip});
  @override
  String toString() {
    // TODO: implement toString
    return 'instruction :$instruction + Tip : $cookingTip***********\n';
  }
}
