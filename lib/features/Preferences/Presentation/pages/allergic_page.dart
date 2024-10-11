import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ukla_app/core/Presentation/resources/colors_manager.dart';
import 'package:ukla_app/features/Preferences/Domain/use_case/allergy_service.dart';
import 'package:ukla_app/features/Preferences/Presentation/widgets/GridItem.dart';
import 'package:ukla_app/features/Preferences/Presentation/pages/preferences_screen.dart';
import 'package:ukla_app/features/body_needs_estimation/presentation/pages/instructions.dart';
import '../../../../core/Presentation/components/error_widget.dart';
import '../../../../models/item_allergies.dart';
import '../../Domain/entities/allergy.dart';

class AllergicPage extends StatefulWidget {
  final bool? fromSettings;
  const AllergicPage({Key? key, this.fromSettings}) : super(key: key);

  @override
  _AllergicPageState createState() => _AllergicPageState();
}

class _AllergicPageState extends State<AllergicPage> {
  List<ItemAllergies> itemList = [];
  List<ItemAllergies> selectedList = [];
  List<Allergy> allergies = [];
  List<Allergy> selectedAllergies = [];
  bool loading = true;
  bool listLoaded = true;
  bool loadingList = true;
  Future<List<Allergy>> loadAllergies() async {
    allergies = await AllergyService.getAllAllergies();
    return allergies;
  }

  Future<List<Allergy>> loadSelectedAllergies() async {
    selectedAllergies = await AllergyService.getSelectedAllergies();
    return selectedAllergies;
  }

  Future<bool> addAllergies(List<int> allergiesId) async {
    return await AllergyService.addAllergies(allergiesId);
  }

  loadList() {
    setState(() {
      for (var allergy in allergies) {
        if (findAllergy(allergy.id)) {
          itemList.add(ItemAllergies(
              allergy.id, allergy.imageId, 1, allergy.name, true));
        } else {
          itemList.add(ItemAllergies(
              allergy.id, allergy.imageId, 1, allergy.name, false));
        }
      }
    });
  }

  bool findAllergy(int id) {
    for (var selectedAllergy in selectedAllergies) {
      if (id == selectedAllergy.id) {
        return true;
      }
    }
    return false;
  }

  loadSelectedList() {
    for (var allergyItem in itemList) {
      for (var selectedAllergy in selectedAllergies) {
        if (selectedAllergy.id == allergyItem.id) {
          setState(() {
            selectedList.add(allergyItem);
          });
        }
      }
    } //for end
  }

  @override
  void initState() {
    loadAllergies();
    loadSelectedAllergies();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (allergies.isNotEmpty) {
        loadList();
        loadSelectedList();
      } else {
        setState(() {
          listLoaded = false;
        });
      }
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          loadingList = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    Color grey = const Color(0XFFF4F4F4);
    return Scaffold(
      // appBar: getAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back))
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: 10, right: width / 10, left: width / 10),
                child:  Text(
                  "Do you have any food allergies ?",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0XFFFA6375),
                      letterSpacing: 0),
                ),
              ),
              SizedBox(
                height: height * 0.025,
              ),
              if (loadingList) ...[
                SizedBox(
                  height: height / 1.5,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: AppColors.secondaryColor, strokeWidth: 2.0,),
                    ],
                  ),
                ),
              ] else if (listLoaded) ...[
                Padding(
                  padding: EdgeInsets.only(right: width / 15, left: width / 15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      width: width,
                      height: height * 0.62,
                      // color: Color(0XFFF4F4F4),
                      decoration: BoxDecoration(
                          color: grey, borderRadius: BorderRadius.circular(26)),
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width / 15),
                        child: GridView.builder(
                            itemCount: itemList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (context, index) {
                              return GridItem(
                                item: itemList[index],
                                isSelected: (bool value) {
                                  setState(() {
                                    if (value &&
                                        !selectedList
                                            .contains(itemList[index])) {
                                      selectedList.add(itemList[index]);
                                    } else {
                                      selectedList.remove(itemList[index]);
                                    }
                                  });
                                },
                                key: Key(itemList[index].rank.toString()),
                                initallySelected: itemList[index].isSelected,
                              );
                            }),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (loading) ...[
                  if (widget.fromSettings != null &&
                      widget.fromSettings != true) ...[
                    Padding(
                      padding:
                          EdgeInsets.only(right: width / 9, left: width / 9),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Preferences()));
                              },
                              child: const Text("Skip")),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0XFFFA6375),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            // onPressed: onPressed,
                            onPressed: () async {
                              setState(() {
                                loading = false;
                              });
                              List<int> allergiesId = [];
                              for (var selectedItem in selectedList) {
                                allergiesId.add(selectedItem.id);
                              }
                              bool response = await addAllergies(allergiesId);
                              await Future.delayed(
                                  const Duration(milliseconds: 600));
                              setState(() {
                                loading = true;
                              });
                              if (response) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        // donot delete replaced likedrecipe page by instructions because it's not completed
                                        //      builder: ((context) => LikedRecipesPage())));
                                        builder: ((context) =>
                                            const Instructions(showBackArrow: false,))));
                              } else {
                                var snackBar = SnackBar(
                                  backgroundColor: const Color(0XFFFA6375),
                                  content: Text(
                                    "There has been an issue, allergies were not added Successfully ",
                                    style: TextStyle(fontSize: 16.sp),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            child:  Text(
                              "Next",
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    )
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0XFFFA6375),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            loading = false;
                          });
                          List<int> allergiesId = [];
                          for (var selectedItem in selectedList) {
                            allergiesId.add(selectedItem.id);
                          }
                          bool response = await addAllergies(allergiesId);
                          await Future.delayed(
                              const Duration(milliseconds: 600));
                          setState(() {
                            loading = true;
                          });
                          if (response) {
                            var snackBar = SnackBar(
                              backgroundColor: const Color(0XFFFA6375),
                              content: Text(
                                "Allergies Updated Successfully",
                                style: TextStyle(fontSize: 16.sp),
                                textAlign: TextAlign.center,
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            var snackBar = SnackBar(
                              backgroundColor: const Color(0XFFFA6375),
                              content: Text(
                                "There has been an issue, allergies were not Updated Successfully ",
                                style: TextStyle(fontSize: 16.sp),
                                textAlign: TextAlign.center,
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        child:  Text(
                          "Update Allergies",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ]
                ] else ...[
                  const CircularProgressIndicator(color: AppColors.secondaryColor, strokeWidth: 2.0,) ,
                ],
              ] else ...[
                const ErrorCustomizedWidget(),
              ]
            ],
          ),
        ),
      ),
    );
  }

  getAppBar() {
    return AppBar(
      backgroundColor: const Color(0XFFFA6375),
      title: Text(selectedList.isEmpty
          ? "Multi Selection"
          : "${selectedList.length} item selected"),
      actions: <Widget>[
        selectedList.isEmpty
            ? Container()
            : InkWell(
                onTap: () {
                  setState(() {
                    for (int i = 0; i < selectedList.length; i++) {
                      itemList.remove(selectedList[i]);
                    }
                    selectedList = List.empty();
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.delete),
                ))
      ],
    );
  }
}
