import 'package:flutter/material.dart';
import 'package:my_cake_shop/cake.dart';
import 'package:my_cake_shop/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:numberpicker/numberpicker.dart';
import 'package:toast/toast.dart';

void main() => runApp(CakeOrderScreen());

class CakeOrderScreen extends StatefulWidget {
  final Cake cake;
  final User user;

  const CakeOrderScreen({Key key, this.cake, this.user}) : super(key: key);

  @override
  _CakeOrderScreenState createState() => _CakeOrderScreenState();
}

class _CakeOrderScreenState extends State<CakeOrderScreen> {
  double screenHeight, screenWidth;
  int selectedQty = 0;
  final TextEditingController _remcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedQty = int.parse(widget.cake.quantity) ?? 1;
    _remcontroller.text = widget.cake.remark;
  }

  @override
  Widget build(BuildContext context) {
    var quantity =
        Iterable<int>.generate(int.parse(widget.cake.quantity) + 1).toList();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.yellow[50],
        appBar: AppBar(
          title: Text('Order Screen'),
          backgroundColor: Colors.amber,
        ),
        body: Container(
            child: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          height: screenHeight / 3.8,
                          width: screenWidth / 0.1,
                          child: CachedNetworkImage(
                            imageUrl:
                                "http://rachelcake.com/mycakeshop/images/cakeimages/${widget.cake.image}.jpg",
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                new CircularProgressIndicator(),
                            errorWidget: (context, url, error) => new Icon(
                              Icons.broken_image,
                              size: screenWidth / 2,
                            ),
                          )),
                      SizedBox(height: 15),
                      Row(children: [
                        Text("Name: ",
                            style: TextStyle(
                              fontSize: 18,
                            )),
                        Text(widget.cake.cakename,
                            style: TextStyle(
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                                color: Colors.purple[900])),
                      ]),
                      SizedBox(height: 15),
                      Row(children: [
                        Text("Price per piece: RM",
                            style: TextStyle(
                              fontSize: 18,
                            )),
                        Text(widget.cake.cakeprice + ".00 ",
                            style: TextStyle(fontSize: 20)),
                      ]),
                      Row(
                        children: [
                          Text("Please Select Quantity: ",
                              style: TextStyle(fontSize: 18)),
                          SizedBox(width: 10),
                          NumberPicker.integer(
                            initialValue: selectedQty,
                            minValue: 1,
                            maxValue: quantity.length - 1,
                            step: 1,
                            zeroPad: false,
                            onChanged: (value) =>
                                setState(() => selectedQty = value),
                          ),
                          Text("piece", style: TextStyle(fontSize: 18)),
                        ],
                      ),
                      Row(children: [
                        Text("Total Price: RM ",
                            style: TextStyle(fontSize: 18)),
                        Text(
                            (selectedQty * double.parse(widget.cake.cakeprice))
                                .toStringAsFixed(2),
                            style: TextStyle(fontSize: 20))
                      ]),
                      SizedBox(height: 15),
                      Row(children: [
                        Text("If you have any remark, please fill it.",
                            style: TextStyle(
                              fontSize: 18,
                            ))
                      ]),
                      TextField(
                        style: TextStyle(fontSize: 20),
                        controller: _remcontroller,
                        keyboardType: TextInputType.text,
                        maxLines: 2,
                        decoration: InputDecoration(
                            hintText: 'Your Remark',
                            hintStyle: TextStyle(color: Colors.grey),
                            icon: Icon(Icons.notes)),
                      ),
                      SizedBox(height: 30),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minWidth: 300,
                        height: 50,
                        child: Text('Add/Update Cart',
                            style: TextStyle(fontSize: (18))),
                        color: Colors.orange[800],
                        textColor: Colors.white,
                        elevation: 15,
                        onPressed: _onOrderDialog,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ))));
  }

  void _onOrderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Confirmation Dialog",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are you sure you want to order " +
                selectedQty.toString() +
                " piece of " +
                widget.cake.cakename +
                "?",
            style: TextStyle(color: Colors.blue[900], fontSize: 18),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _orderCake();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _orderCake() {
    http.post("http://rachelcake.com/mycakeshop/php/insert_cart.php", body: {
      "email": widget.user.email,
      "cakeid": widget.cake.cakeid,
      "cakeqty": selectedQty.toString(),
      "remark": _remcontroller.text,
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
}
