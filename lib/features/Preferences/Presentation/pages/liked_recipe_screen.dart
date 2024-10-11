import 'package:flutter/material.dart';
import 'package:ukla_app/features/Preferences/Presentation/widgets/CardLikedRecipe.dart';

import 'package:ukla_app/features/Preferences/Presentation/pages/allergic_page.dart';
import 'package:ukla_app/features/body_needs_estimation/presentation/pages/instructions.dart';
import 'package:ukla_app/models/ItemAllegies.dart';

class LikedRecipesPage extends StatefulWidget {
  const LikedRecipesPage({Key? key}) : super(key: key);

  @override
  _LikedRecipesPageState createState() => _LikedRecipesPageState();
}

class _LikedRecipesPageState extends State<LikedRecipesPage> {
  List<Item>? itemList;
  List<Item>? selectedList;

  @override
  void initState() {
    loadList();
    super.initState();
  }

  loadList() {
    itemList = [];
    selectedList = [];
    itemList!.add(Item("assets/images/preferences/dairy.jpg", 1, "Dairy"));
    itemList!.add(Item("assets/images/getstarted.jpg", 2, "frensh breakfast"));
    itemList!
        .add(Item("assets/images/preferences/chiken.jpg", 3, "chicken wings"));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    Color grey = const Color(0XFFF4F4F4);
    return Scaffold(
      //appBar: //getAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: 0.055 * height,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: 10, right: width / 10, left: width / 10),
                child: const Text(
                  "Which one of these do you like ?",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0XFFFA6375),
                      letterSpacing: 0),
                ),
              ),
              SizedBox(
                height: height * 0.025,
              ),
              Padding(
                padding: EdgeInsets.only(right: width / 15, left: width / 15),
                child: Container(
                  width: width,
                  height: height * 0.6,
                  // color: Color(0XFFF4F4F4),
                  decoration: BoxDecoration(
                      color: grey, borderRadius: BorderRadius.circular(26)),
                  child: Padding(
                    padding: EdgeInsets.all(width / 15),
                    child: GridView.builder(
                        itemCount: itemList!.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 135,
                          // crossAxisSpacing: 12,
                          mainAxisSpacing: 1,
                          crossAxisCount: 1,
                        ),
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              LikedRecipeCard(
                                  item: itemList![index],
                                  isSelected: (bool value) {
                                    setState(() {
                                      if (value) {
                                        selectedList!.add(itemList![index]);
                                      } else {
                                        selectedList!.remove(itemList![index]);
                                      }
                                    });
                                  },
                                  key: Key(itemList![index].rank.toString())),
                            ],
                          );
                        }),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(right: width / 9, left: width / 9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AllergicPage()));
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
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const Instructions(showBackArrow: false))));
                      },
                      child: const Text(
                        "Next",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getAppBar() {
    return AppBar(
      backgroundColor: const Color(0XFFFA6375),
      title: Text(selectedList!.isEmpty
          ? "Multi Selection"
          : "${selectedList!.length} item selected"),
      actions: <Widget>[
        selectedList!.isEmpty
            ? Container()
            : InkWell(
                onTap: () {
                  setState(() {
                    for (int i = 0; i < selectedList!.length; i++) {
                      itemList!.remove(selectedList![i]);
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
