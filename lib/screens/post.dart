import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: 'Post Screen'.text.make(),
      ),
    );
  }
}
