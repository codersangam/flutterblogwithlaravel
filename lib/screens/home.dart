import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Home'.text.make(),
      ),
    );
  }
}
