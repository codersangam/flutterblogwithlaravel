import 'package:flutter/material.dart';
import 'package:flutterblogwithlaravel/constant.dart';
import 'package:flutterblogwithlaravel/models/api_response.dart';
import 'package:flutterblogwithlaravel/models/user.dart';
import 'package:flutterblogwithlaravel/screens/register.dart';
import 'package:flutterblogwithlaravel/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login> {
  String name = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    ApiResponse response = await login(txtEmail.text, txtPassword.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/login.png",
                      fit: BoxFit.cover,
                    ),
                    Text(
                      "Welcome $name!",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: txtEmail,
                            decoration:
                                kInputDecoration("Email", "Enter Email"),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Email is required";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              name = value;
                              setState(() {});
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: txtPassword,
                            obscureText: true,
                            decoration:
                                kInputDecoration('Password', 'Enter Password'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Password is required";
                              } else if (value.length < 8) {
                                return "Password length must be greater than 8 characters";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          loading
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : kSizedButton("LOGIN", () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      loading = true;
                                      _loginUser();
                                    });
                                  }
                                }),
                          SizedBox(height: 40),
                          kLoginAndRegisterHint(
                              "Don't have an Account? ", "Register", () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => Register()),
                                (route) => false);
                          })
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
