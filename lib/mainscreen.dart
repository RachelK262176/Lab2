import 'package:flutter/material.dart';
import 'package:my_cake_shop/cake.dart';
import 'package:my_cake_shop/cakescreen.dart';
import 'package:my_cake_shop/loginscreen.dart';
import 'package:my_cake_shop/shoppingcartscreen.dart';
import 'package:my_cake_shop/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  List cakeList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Cake...";
  bool visible = false;
  //var ratingList = {"Highest", "Lowest"};

  @override
  void initState() {
    super.initState();
    _loadCake();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _cakenamecontroller = TextEditingController();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.pink[50],
        appBar: AppBar(
          title: Text('Welcome To Our Shop',
              style: TextStyle(fontSize: 20, color: Colors.white)),
          backgroundColor: Colors.pink[900],
          actions: <Widget>[
            /*Container(
                width: screenWidth / 2.2,
                padding: EdgeInsets.fromLTRB(3, 10, 1, 10),
                child: TextField(
                  autofocus: false,
                  controller: _cakenamecontroller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(5.0),
                      ),
                    ),
                    prefixIcon: Icon(Icons.cake),
                  ),
                )),
            SizedBox(width: 5),*/
            Flexible(
              child: IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white, size: 35),
                onPressed: () {
                  _shoppinCartScreen();
                },
              ),
            ),
            Flexible(
              child: IconButton(
                icon: Icon(Icons.logout),
                iconSize: 35,
                onPressed: () {
                  _logout();
                },
              ),
            ),
          ],
        ),
        body: Column(children: [
          cakeList == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ))))
              : Flexible(
                  child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: (screenWidth / screenHeight) / 0.70,
                  children: List.generate(cakeList.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(1),
                        child: Card(
                            color: Colors.pink[100],
                            child: InkWell(
                              onTap: () => _loadCakeDetail(index),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 3),
                                    Stack(
                                      children: [
                                        Container(
                                            height: screenHeight / 1.9,
                                            width: screenWidth / 1.0,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "http://rachelcake.com/mycakeshop/images/cakeimages/${cakeList[index]['image']}.jpg",
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  new CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      new Icon(
                                                Icons.broken_image,
                                                size: screenWidth / 2,
                                              ),
                                            )),
                                        Positioned(
                                          child: Container(
                                              //color: Colors.white,
                                              margin: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: Colors.white,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15))),
                                              child: Row(
                                                children: [
                                                  Text(
                                                      cakeList[index][
                                                          'rating'], // text cannot be null and cakerating != rating!!!
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16)),
                                                  Icon(Icons.star,
                                                      color: Colors.redAccent),
                                                ],
                                              )),
                                          bottom: 10,
                                          right: 10,
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      cakeList[index]['cakename'],
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo[900]),
                                    ),
                                    Text(
                                      "RM " +
                                          cakeList[index]['cakeprice'] +
                                          ".00 per piece",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo[800]),
                                    ),
                                  ],
                                ),
                              ),
                            )));
                  }),
                ))
        ]),
      ),
    );
  }

  Future<void> _loadCake() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    await pr.show();
    http.post("http://rachelcake.com/mycakeshop/php/load_cake.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        cakeList = null;
        setState(() {
          titlecenter = "No Cake Found";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          cakeList = jsondata["cake"];
        });
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  _loadCakeDetail(int index) {
    print(cakeList[index]['cakename']);
    Cake cake = new Cake(
        cakeid: cakeList[index]['cakeid'],
        cakename: cakeList[index]['cakename'],
        cakeprice: cakeList[index]['cakeprice'],
        quantity: cakeList[index]['quantity'],
        ingredients: cakeList[index]['ingredients'],
        step: cakeList[index]['step'],
        image: cakeList[index]['image'],
        rating: cakeList[index]['rating'],
        remark: cakeList[index]['remark']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CakeScreen(
                  cake: cake,
                  user: widget.user,
                )));
  }

  void _shoppinCartScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ShoppingCartScreen(
                  user: widget.user,
                )));
  }

  void _logout() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }
}
