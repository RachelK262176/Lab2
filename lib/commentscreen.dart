import 'package:flutter/material.dart';
import 'package:my_cake_shop/cake.dart';
import 'package:my_cake_shop/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:toast/toast.dart';

void main() => runApp(CommentScreen());

class CommentScreen extends StatefulWidget {
  final Cake cake;
  final User user;

  const CommentScreen({Key key, this.cake, this.user}) : super(key: key);
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List cmdList;
  int numcomment = 0;
  double screenHeight, screenWidth;
  String titlecenter = "Nothing...";
  final TextEditingController _commentcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _loadComment();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text(widget.cake.cakename),
        backgroundColor: Colors.lightBlue[900],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        onPressed: () {
          _addComment();
          //_bookScreen();
        },
        icon: Icon(Icons.add_comment, color: Colors.blueGrey, size: 40),
        label: Text(""),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          cmdList == null
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
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 5, color: Colors.green[50]),
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(8)),
                      ),
                      margin: const EdgeInsets.all(1),
                      child: Column(children: [
                        Text(widget.cake.remark,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                      ]))),
        ],
      )),
    );
  }

  /*void _loadComment() {
    http.post("http://rachelcake.com/mycakeshop/php/load_comment.php", body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        cmdList = null;
        setState(() {
          titlecenter = "No Comment Found";
        });
      } else {
        numcomment = 0;
        setState(() {
          var jsondata = json.decode(res.body);
          cmdList = jsondata["cmd"];
          /*for (int i = 0; i < cmdList.length; i++) {
            totalPrice = totalPrice +
                double.parse(cartList[i]['cakeprice']) *
                    int.parse(cartList[i]['quantity']);
            numcart = numcart + int.parse(cartList[i]['quantity']);
          }
          restName = cartList[0]['restname'];
          restlat = double.parse(cartList[0]['restlat']);
          restlon = double.parse(cartList[0]['restlon']);
          restdel = double.parse(cartList[0]['restdel']);
          _calculatePayment();*/
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _send() {
    http.post("http://rachelcake.com/mycakeshop/php/insert_comment.php", body: {
      "email": widget.user.email,
      "cakeid": widget.cake.cakeid,
      "comment": _commentcontroller,
      "image": widget.cake.image,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        Navigator.pop(context);
      } else {
        Toast.show(
          "Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }
}*/

  void _addComment() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Do you want to say something?',
          style: TextStyle(
              //color: Colors.white,
              ),
        ),
        content: new TextField(
          style: TextStyle(fontSize: 20),
          controller: _commentcontroller,
          keyboardType: TextInputType.text,
          maxLines: 4,
          decoration: InputDecoration(
              hintText: 'Lets say something! ',
              hintStyle: TextStyle(color: Colors.grey),
              icon: Icon(Icons.notes)),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                _send();
              },
              child: Text(
                "Ok",
                style: TextStyle(
                    //color: Color.fromRGBO(101, 255, 218, 50),
                    ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                    //color: Color.fromRGBO(101, 255, 218, 50),
                    ),
              )),
        ],
      ),
    );
  }

  void _send() {}
}
