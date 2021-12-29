import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/controller/myprovider.dart';
import 'package:task/models/images.dart';

class mainscreen extends StatefulWidget {
  const mainscreen({Key? key}) : super(key: key);

  @override
  _mainscreenState createState() => _mainscreenState();
}

class _mainscreenState extends State<mainscreen> {
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<myprovider>(context, listen: false).getimages();
  }

  List searchedlist = [];
  late List allimages =
      Provider.of<myprovider>(context, listen: false).allimages;

  bool issearched = false;
  var searchtextcontroller = TextEditingController();

  Widget buildsearchfield() {
    return TextField(
      textAlign: TextAlign.left,
      controller: searchtextcontroller,
      cursorColor: Colors.grey,
      decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Find an image ",
          hintStyle: TextStyle(fontSize: 18, color: Colors.black38)),
      style: const TextStyle(fontSize: 18, color: Colors.black38),
      onChanged: (searchtextcontroller) {
        addsearcheditemtosearchedlist(searchtextcontroller);
      },
    );
  }

  void addsearcheditemtosearchedlist(String serachedcharacter) {
    searchedlist = allimages
        .where((img) => img.alt.toLowerCase().startsWith(serachedcharacter))
        .toList();
    setState(() {
      issearched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !issearched
          ? AppBar(
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
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        issearched = true;
                      });
                    },
                    icon: const Icon(Icons.search_rounded))
              ],
              title: const Text(
                "images",
                style: TextStyle(color: Colors.black38),
              ),
            )
          : AppBar(
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
              leading: IconButton(
                  onPressed: () {
                    setState(() {
                      issearched = false;
                    });
                  },
                  icon: Icon(Icons.arrow_back)),
              title: buildsearchfield(),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        searchtextcontroller.clear();
                        issearched = false;
                      });
                    },
                    icon: Icon(Icons.clear))
              ],
            ),
      body: Consumer<myprovider>(
        builder: (context, value, _) => GridView.builder(
            padding: EdgeInsets.all(15),
            itemCount:
                issearched ? searchedlist.length : value.allimages.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10),
            itemBuilder: (context, index) {
              return !issearched
                  ? InkWell(
                      onTap: () => Navigator.of(context)
                          .pushNamed('Wallpaper_Details_Screen', arguments: {
                        'index': index,
                        'list': null,
                      }),
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Hero(
                            tag: 'tagImage$index',
                            child: FadeInImage(
                                placeholder:
                                    const AssetImage("assets/loading.gif"),
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    value.allimages[index].src.large)),
                          ),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () => Navigator.of(context)
                          .pushNamed('Wallpaper_Details_Screen', arguments: {
                        'index': index,
                        'list': searchedlist,
                      }),
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Hero(
                            tag: 'tagImage$index',
                            child: FadeInImage(
                                placeholder:
                                    const AssetImage("assets/loading.gif"),
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    searchedlist[index].src.large)),
                          ),
                        ),
                      ),
                    );
            }),
      ),
    );
  }
}
