import 'package:flutter/material.dart';
import 'package:flutterblogwithlaravel/constant.dart';
import 'package:flutterblogwithlaravel/models/api_response.dart';
import 'package:flutterblogwithlaravel/models/user.dart';
import 'package:flutterblogwithlaravel/screens/login.dart';
import 'package:flutterblogwithlaravel/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool loading = false;

  void _registerUser() async {
    ApiResponse response = await register(
        nameController.text, emailController.text, passwordController.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = !loading;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('{$response.error}'),
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
      child: SafeArea(
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
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: kInputDecoration("Name", "Full Name"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Invalid Name";
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: kInputDecoration("Email", "Enter email"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email is required";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: passwordController,
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
                          height: 10,
                        ),
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: kInputDecoration(
                              'Confirm Password', 'Confirm Password'),
                          validator: (value) => value != passwordController.text
                              ? 'Confirm Password does not match'
                              : null,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        loading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : kSizedButton("REGISTER", () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    loading = !loading;
                                    _registerUser();
                                  });
                                }
                              }),
                        SizedBox(height: 40),
                        kLoginAndRegisterHint(
                            "Already have an Account? ", "Login", () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => Login()),
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
    );
  }
}
