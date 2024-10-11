import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ukla_app/core/Data/storage.dart';
import 'package:ukla_app/core/Presentation/resources/strings_manager.dart';

class IngredientDB {
  int id;
  String imageAsString;
  IngredientDB({required this.id, required this.imageAsString});
  IngredientDB.fromMap(Map<String, dynamic> ingredient)
      : id = ingredient["id"],
        imageAsString = ingredient["image"];

  Map<String, Object> toMap() {
    return {'id': id, 'image': imageAsString};
  }
}

class SqliteService {
  static Future<Database> initializeDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ingredients_database.db");
    //   String path = await getDatabasesPath()
    return await openDatabase(
      path,
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE ingredients(id INTEGER PRIMARY KEY,image TEXT)",
        );
      },
      version: 1,
    );
  }

  static Future<Uint8List> getIngredient(int ingredientId) async {
    final Database db = await initializeDB();
    //check if the ingredient exists in db
    List<Map> result = await db
        .rawQuery('SELECT * FROM ingredients WHERE id=?', [ingredientId]);
    if (result.isEmpty) {
      ///get the ingredient
      var image = await http.get(
        Uri.parse(
            "${AppString.SERVER_IP}/ukla/file-system/image/$ingredientId"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': 'Bearer ${await storage.read(key: "jwt")}',
        },
      );

      //convert to byte and creating an ingredient instance
      String imgString = Utility.base64String(image.bodyBytes);
      IngredientDB ingredient =
          IngredientDB(id: ingredientId, imageAsString: imgString);
      await db.insert("ingredients", ingredient.toMap());

      return Utility.dataFromBase64String(imgString);
    }

    ///send the image
    return Utility.dataFromBase64String(result[0]["image"]);
  }
}

class Utility {
  //string64 to image not used till now

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.cover,
      height: 80,
      width: 80,
    );
  }

//string64 to bytes
  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
