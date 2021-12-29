import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/controller/myprovider.dart';

import 'view/screens/Wallpaper_Details_Screen.dart';
import 'view/screens/favourit_screen.dart';
import 'view/screens/mainscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<Map<String, Object>> pages;
  initState() {
    pages = [
      {'page': mainscreen(), 'title': "Images"},
      {
        'page': favourit_screen(),
        'title': "My Favorites",
      }
    ];
    super.initState();
  }

  int selectedindex = 0;
  void selectpage(int value) {
    setState(() {
      selectedindex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<myprovider>(
        create: (_) => myprovider(),
        child: MaterialApp(
            routes: {
              "Wallpaper_Details_Screen": (context) =>
                  Wallpaper_Details_Screen()
            },
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: pages[selectedindex]['page'] as Widget,
              bottomNavigationBar: BottomNavigationBar(
                onTap: selectpage,
                selectedItemColor: Colors.orange,
                unselectedItemColor: Colors.black,
                currentIndex: selectedindex,
                backgroundColor: Colors.pink,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.category),
                    label: ("Images"),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: ("Favorite"),
                  )
                ],
              ),
            )));
  }
}
