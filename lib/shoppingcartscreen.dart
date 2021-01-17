import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:my_cake_shop/billscreen.dart';
import 'package:my_cake_shop/cake.dart';
import 'package:my_cake_shop/cakescreen.dart';
import 'package:my_cake_shop/user.dart';
import 'package:toast/toast.dart';
import 'package:date_format/date_format.dart';

class ShoppingCartScreen extends StatefulWidget {
  final User user;

  const ShoppingCartScreen({Key key, this.user}) : super(key: key);

  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  List cartList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Cart...";
  final formatter = new NumberFormat("#,##");
  double totalPrice = 0.0;
  String cakeName = "";
  int numcart = 0;
  int _radioValue = 0;
  String _delivery = "Pickup";
  bool _stpickup = true;
  bool _stdeli = false;
  String _homeloc = "searching...";
  //Position _currentPosition;
  bool _visible = false;
  double sizing = 11.5;
  String gmaploc = "";
  TextEditingController _timeController = TextEditingController();
  double latitude, longitude, cakePrice, quantity;
  //Completer<GoogleMapController> _controller = Completer();
  //GoogleMapController gmcontroller;
  //CameraPosition _home;
  //MarkerId markerId1 = MarkerId("12");
  //Set<Marker> markers = Set();
  //CameraPosition _userpos;
  double distance = 0.0;
  double restdel = 0.0;
  double delcharge = 0.0;
  double payable = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text('Your Shopping Cart'),
        backgroundColor: Colors.orange[900],
      ),
      body: Column(
        children: [
          cartList == null
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
                  childAspectRatio: (screenWidth / screenHeight) / 0.2,
                  children: List.generate(cartList.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(1),
                        child: Card(
                            child: InkWell(
                          onTap: () => _loadCakeDetails(index),
                          onLongPress: () => _deleteOrderDialog(index),
                          child: SingleChildScrollView(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: screenHeight / 6,
                                    width: screenWidth / 4,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "http://rachelcake.com/mycakeshop/images/cakeimages/${cartList[index]['image']}.jpg",
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          new CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          new Icon(
                                        Icons.broken_image,
                                        size: screenWidth / 2,
                                      ),
                                    )),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartList[index]['cakename'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("RM " +
                                        cartList[index]['cakeprice'] +
                                        " x " +
                                        cartList[index]['cakeqty'] +
                                        " piece"),
                                    Text("Total RM " +
                                        (double.parse(cartList[index]
                                                    ['cakeprice']) *
                                                int.parse(
                                                    cartList[index]['cakeqty']))
                                            .toStringAsFixed(2))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )));
                  }),
                )),
          Container(
              decoration: new BoxDecoration(
                color: Colors.red[100],
              ),
              height: screenHeight / sizing,
              width: screenWidth / 0.4,
              child: Card(
                  elevation: 15,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: IconButton(
                            icon: _visible
                                ? new Icon(Icons.expand_more)
                                : new Icon(Icons.attach_money),
                            onPressed: () {
                              setState(() {
                                if (_visible) {
                                  _visible = false;
                                  sizing = 11.5;
                                } else {
                                  _visible = true;
                                  sizing = 1.2;
                                }
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "TOTAL ITEM/S",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(widget.user.name +
                            ", there are " +
                            numcart.toString() +
                            " item/s in your cart"),
                        // Text("Total amount is RM " +
                        //     totalPrice.toStringAsFixed(2)),
                        SizedBox(height: 10),
                        Divider(height: 1, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          "DELIVERY OPTIONS ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Pickup"),
                            new Radio(
                              value: 0,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChange,
                            ),
                            /* Text("Delivery"),
                            new Radio(
                              value: 1,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChange,
                            ),*/
                          ],
                        ),
                        Divider(height: 2, color: Colors.grey),
                        SizedBox(height: 10),
                        Visibility(
                            visible: _stpickup,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "SELF PICKUP",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Set pickup time at ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        _timeController.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 20),
                                      Container(
                                          width: 20,
                                          child: IconButton(
                                              iconSize: 32,
                                              icon: Icon(Icons.watch),
                                              onPressed: () =>
                                                  {_selectTime(context)})),
                                    ])
                              ],
                            )),
                        SizedBox(height: 5),
                        Visibility(
                            visible: _stdeli,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: screenWidth / 2,
                                    child: Column(
                                      children: [
                                        Text(
                                          "DELIVERY ADDRESS ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10),
                                        Text(_homeloc),
                                        SizedBox(height: 5),
                                        GestureDetector(
                                          child: Text("Set/Change Location?",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          onTap: () => {
                                            //_loadMapDialog(),
                                          },
                                        ),
                                        SizedBox(height: 5),
                                      ],
                                    )),
                              ],
                            )),
                        SizedBox(height: 5),
                        Divider(height: 1, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          "PAYMENT ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 3),
                        /*Text("Distance from restaurant " +
                            distance.toStringAsFixed(2) +
                            " KM"),
                        Text("Delivery Charge RM " +
                            delcharge.toStringAsFixed(2)),*/
                        Text(
                            "Food/s price RM:" + totalPrice.toStringAsFixed(2)),
                        Text("Total amount payable RM " +
                            payable.toStringAsFixed(2)),
                        //SizedBox(height: 5),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          height: 30,
                          child: Text('Make Payment'),
                          color: Colors.red,
                          textColor: Colors.white,
                          elevation: 10,
                          onPressed: () => {
                            _makePaymentDialog(),
                          },
                        ),
                      ],
                    ),
                  ))),
        ],
      ),
    ));
  }

  void _loadCart() {
    http.post("http://rachelcake.com/mycakeshop/php/load_cart.php", body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        cartList = null;
        setState(() {
          titlecenter = "No Item Found";
        });
      } else {
        totalPrice = 0;
        numcart = 0;
        setState(() {
          var jsondata = json.decode(res.body);
          cartList = jsondata["cart"];
          for (int i = 0; i < cartList.length; i++) {
            totalPrice = totalPrice +
                double.parse(cartList[i]['cakeprice']) *
                    int.parse(cartList[i]['cakeqty']);
            numcart = numcart + int.parse(cartList[i]['cakeqty']);
          }
          cakeName = cartList[0]['cakename'];
          //cakePrice = double.parse(cartList[0]['cakeprice']);
          //quantity = double.parse(cartList[0]['quantity']);
          //restdel = double.parse(cartList[0]['restdel']);
          _calculatePayment();
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadCakeDetails(int index) async {
    Cake curcake = new Cake(
        cakeid: cartList[index]['cakeid'],
        cakename: cartList[index]['cakename'],
        cakeprice: cartList[index]['cakeprice'],
        quantity: cartList[index]['quantity'],
        image: cartList[index]['image'],
        remark: cartList[index]['remark']);

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CakeScreen(
                  cake: curcake,
                  user: widget.user,
                )));
    _loadCart();
  }

  _deleteOrderDialog(int index) {
    print("Delete " + cartList[index]['cakename']);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Delete order " + cartList[index]['cakename'] + "?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are your sure? ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _deleteCart(index);
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
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

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          _delivery = "Pickup";
          _stpickup = true;
          _stdeli = false;
          _calculatePayment();
          break;
        case 1:
          _delivery = "Delivery";
          _stpickup = false;
          _stdeli = true;
          //_getLocation();
          break;
      }
      print(_delivery);
    });
  }

  void _deleteCart(int index) {
    http.post("http://rachelcake.com/mycakeshop/php/delete_cart.php", body: {
      "email": widget.user.email,
      "cakeid": cartList[index]['cakeid'],
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        _loadCart();
        Toast.show(
          "Delete Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      } else {
        Toast.show(
          "Delete failed!!!",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _calculatePayment() {
    setState(() {
      if (_delivery == "Pickup") {
        distance = 0;
        delcharge = restdel * distance;
        payable = totalPrice + delcharge;
      } else {
        delcharge = restdel * distance;
        payable = totalPrice + delcharge;
      }
    });
  }

  _makePaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Proceed with payment?',
          style: TextStyle(
              //color: Colors.white,
              ),
        ),
        content: new Text(
          'Are you sure to pay RM ' + payable.toStringAsFixed(2) + "?",
          style: TextStyle(
              //color: Colors.white,
              ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                _makePayment();
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

  Future<void> _makePayment() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => BillScreen(
                  user: widget.user,
                  val: payable.toStringAsFixed(2),
                )));
    _calculatePayment();
    _loadCart();
  }

  _selectTime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
    String _hour, _minute, _time;
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }
}
