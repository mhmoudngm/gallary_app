import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/controller/myprovider.dart';
import 'package:like_button/like_button.dart';
import 'package:dio/dio.dart';

class Wallpaper_Details_Screen extends StatefulWidget {
  const Wallpaper_Details_Screen({Key? key}) : super(key: key);

  @override
  _Wallpaper_Details_ScreenState createState() =>
      _Wallpaper_Details_ScreenState();
}

class _Wallpaper_Details_ScreenState extends State<Wallpaper_Details_Screen> {
  bool isfavourit = false;
  _save(var index) async {
    var response = await Dio().get(
        Provider.of<myprovider>(context, listen: false)
            .allimages[index]
            .src
            .large,
        options: Options(responseType: ResponseType.bytes));
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 60,
          name: "hello");
      print(result);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text("Image saved successfully at $result"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      "close",
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final routearg =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    final imageindex = routearg['index'] as int;
    final imageslist = routearg['list'] as List;
    var provider = Provider.of<myprovider>(context, listen: false);
    Future<bool> onLikeButtonTapped(bool isLiked) async {
      if (imageslist == null) {
        provider.favouritimages(provider.allimages[imageindex].src.large);
      } else {
        provider.favouritimages(imageslist[imageindex].src.large);
      }
      return !isLiked;
    }

    return Hero(
      tag: 'tagImage$imageindex',
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: imageslist == null
                    ? NetworkImage(provider.allimages[imageindex].src.large)
                    : NetworkImage(imageslist[imageindex].src.large))),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Colors.pink,
                    Colors.red,
                  ])),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    _save(imageindex);
                  },
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: const Icon(
                      Icons.download,
                      size: 50,
                      color: Colors.pink,
                    ),
                  ),
                ),
                Container(
                  child: LikeButton(
                    isLiked: isfavourit,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    onTap: onLikeButtonTapped,
                    size: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
