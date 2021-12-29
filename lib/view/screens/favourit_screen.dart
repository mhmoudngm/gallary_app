import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/controller/myprovider.dart';

class favourit_screen extends StatefulWidget {
  @override
  State<favourit_screen> createState() => _favourit_screenState();
}

class _favourit_screenState extends State<favourit_screen> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: FutureBuilder(
          future:
              Provider.of<myprovider>(context, listen: false).favouritimages(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return ListView.builder(
              itemBuilder: (ctx, index) {
                return Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Hero(
                      tag: 'tagImage$index',
                      child: FadeInImage(
                          placeholder: const AssetImage("assets/loading.gif"),
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              Provider.of<myprovider>(context, listen: false)
                                  .favouritlist[index])),
                    ),
                  ),
                );
              },
              itemCount: Provider.of<myprovider>(context, listen: false)
                  .favouritlist
                  .length,
            );
          }),
    );
  }
}
