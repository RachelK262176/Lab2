import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycakeshop/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

final _formKey = GlobalKey<FormState>();

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emcontroller = TextEditingController();
  final TextEditingController _pscontroller = TextEditingController();
  final TextEditingController _phcontroller = TextEditingController();

  String _email = "";
  String _password = "";
  String _name = "";
  String _phone = "";
  bool _passwordVisible = false;
  bool _rememberMe = false;
  bool _termAndCondition = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow[200],
        body: Container(
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
                child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 15),
                  Image.asset(
                    'assets/images/MyCakeShop.png',
                    scale: 0.7,
                  ),
                  TextFormField(
                      controller: _namecontroller,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        icon: Icon(Icons.person),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        //validator
                        if (value.length < 3) {
                          return 'Please enter a correct Name';
                        } else if (value.isEmpty) {
                          return 'Please enter your Name';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (String name) {
                        _name = name;
                      }),
                  TextFormField(
                      controller: _phcontroller,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Mobile',
                        icon: Icon(Icons.phone),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        //validator
                        if (value.length != 10) {
                          return 'Please enter a correct Phone Number';
                        } else if (value.isEmpty) {
                          return 'Please enter your Phone Number';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (String phone) {
                        _phone = phone;
                      }),
                  // SizedBox(height: 5),
                  TextFormField(
                      controller: _emcontroller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        //validator
                        Pattern pattern =
                            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(value)) {
                          return 'Please enter a correct Email';
                        } else if (value.isEmpty) {
                          return 'Please enter your Email';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (String email) {
                        _email = email;
                      }),
                  // SizedBox(height: 5),
                  TextFormField(
                      // key: _passwordFieldKey,
                      controller: _pscontroller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        icon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variablegithu
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: _passwordVisible,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        //validator
                        Pattern pattern =
                            r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(value)) {
                          return 'Please enter a correct Password';
                        } else if (value.isEmpty) {
                          return 'Please enter your Password';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (String password) {
                        _password = password;
                      }),
                  // SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (bool value) {
                          _onChange(value);
                        },
                      ),
                      Text('Remember Me', style: TextStyle(fontSize: 16))
                    ],
                  ),
                  FormField<bool>(
                    builder: (state) {
                      return Column(children: <Widget>[
                        Row(children: <Widget>[
                          Checkbox(
                            value: _termAndCondition,
                            onChanged: (bool value) {
                              _onChange1(value);
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('I agree the ',
                                  style: TextStyle(fontSize: 16)),
                              GestureDetector(
                                onTap: _termCondition,
                                child: Text('Term and Condition',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.blueAccent)),
                              )
                            ],
                          )
                        ])
                      ]);
                    },
                    validator: (value) {
                      if (!_termAndCondition) {
                        return '';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    minWidth: 300,
                    height: 50,
                    child: Text('REGISTER', style: TextStyle(fontSize: 18)),
                    color: Colors.black,
                    textColor: Colors.amber[200],
                    elevation: 15,
                    onPressed: _confirm, //_onRegister,
                  ),
                  SizedBox(height: 12),
                  GestureDetector(
                      onTap: _onLogin,
                      child: Text('Already Register',
                          style: TextStyle(fontSize: 16))),
                ],
              ),
            ))));
  }

  Future<void> _onRegister() async {
    Navigator.pop(context);

    if (_formKey.currentState.validate()) {
      _name = _namecontroller.text;
      _phone = _phcontroller.text;
      _email = _emcontroller.text;
      _password = _pscontroller.text;

      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration...");
      await pr.show();
      http.post("http://rachelcake.com/mycakeshop/php/register_user.php",
          body: {
            "name": _name,
            "phone": _phone,
            "email": _email,
            "password": _password,
          }).then((res) {
        print(res.body);

        if (res.body == "success") {
          Toast.show(
            "Registration success and Please check your mail box to verify the email for login!",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
          );
          if (_rememberMe) {
            savepref();
          }
          _onLogin();
        }
      }).catchError((err) {
        print(err);
      });
      await pr.hide();
    } else {
      Toast.show(
        "Registration Failed",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
      );
    }
  }

  void _onLogin() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void _onChange(bool value) {
    setState(() {
      _rememberMe = value;
    });
  }

  void _onChange1(bool value) {
    setState(() {
      _termAndCondition = value;
    });
  }

  Future<void> savepref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = _emcontroller.text;
    _password = _pscontroller.text;
    await prefs.setString('email', _email);
    await prefs.setString('password', _password);
    await prefs.setBool('rememberMe', true);
  }

  void _confirm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Confirmation Message'),
          content: new Text(
              'Are you sure you want to register? Please make sure your information is correct.'),
          actions: <Widget>[
            Row(children: [
              new FlatButton(
                child: new Text(
                  "Yes",
                  style: Theme.of(context).textTheme.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.blue[300]),
                ),
                onPressed: () {
                  _onRegister();
                },
              ),
              new FlatButton(
                child: new Text(
                  "No",
                  style: Theme.of(context).textTheme.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.blue[300]),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ]),
          ],
        );
      },
    );
  }

  void _termCondition() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Terms And Conditions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
              child: new Text(
                  'Please read these terms and conditions of use carefully before accessing, using or obtaining any materials, information, products or services. By accessing, the My Cake Shop mobile application, you agree to be bound by these terms and conditions("Terms") and our privacy policy. If you do not accept all of these Terms, then you may not use and register our application. In these Terms,  "we", "us", "our" refers to My Cake Shop, and "you" or "your" refers to you as the user of Our Website. THESE TERMS INCLUDE AN ARBITRATION CLAUSE AND A WAIVER OF YOUR RIGHT TO PARTICIPATE IN A CLASS ACTION OR REPRESENTATIVE LAWSUIT.',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic))),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Yes",
                style: Theme.of(context).textTheme.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.blue[300]),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
