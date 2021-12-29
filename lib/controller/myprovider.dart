import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/models/images.dart';

class myprovider with ChangeNotifier {
  List<dynamic> allimages = [];
  List<dynamic> favouritlist = [];
  final url = "https://api.pexels.com/v1/curated?per_page=40";
  Future<void> getimages() async {
    try {
      var response = await http.get(Uri.parse(url), headers: {
        "Authorization":
            "563492ad6f917000010000012fe9d4cf8b0445318d87d51a03aafb64"
      });
      if (response.statusCode == 200) {
        print("success");
        var decodeddata = json.decode(response.body);

        final data = new Map<String, dynamic>.from(decodeddata);

        var images =
            data['photos'].map((image) => Photos.fromJson(image)).toList();
        allimages = images;
      } else {
        print("an error occurs");
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> favouritimages() async {
    var prefs = await SharedPreferences.getInstance();
    favouritlist = prefs.getStringList("imgurl")!;
    notifyListeners();
  }
}
