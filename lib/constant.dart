import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

//<---------STRINGS--------->
const baseURL = 'https://blog.hariomshop.com/api';
const loginURL = baseURL + '/login';
const registerURL = baseURL + '/register';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/user';
const postsURL = baseURL + '/posts';
const commentsURL = baseURL + '/comments';

//<---------ERRORS--------->
const serverError = 'Server Error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';

// <-----INPUT DECORATION---->

InputDecoration kInputDecoration(String label, String hint) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    border: OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.red),
    ),
  );
}

// <------BUTTONS----->

SizedBox kSizedButton(String label, Function onPressed) {
  return SizedBox(
    width: double.infinity,
    height: 40,
    child: ElevatedButton(
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
      onPressed: () => onPressed(),
      child: Text(label),
    ),
  );
}

// Login & Register Hint

Row kLoginAndRegisterHint(String label, String link, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      label.text.make(),
      GestureDetector(
        child: link.text.color(Colors.red).make(),
        onTap: () => onTap(),
      )
    ],
  );
}
