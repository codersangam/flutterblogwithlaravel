import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterblogwithlaravel/constant.dart';
import 'package:flutterblogwithlaravel/models/api_response.dart';
import 'package:flutterblogwithlaravel/models/post.dart';
import 'package:flutterblogwithlaravel/services/post_service.dart';
import 'package:flutterblogwithlaravel/services/user_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

import 'login.dart';

class PostForm extends StatefulWidget {
  final Post? post;
  final String? title;

  PostForm({this.post, this.title});

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController postController = TextEditingController();
  bool _loading = false;

  File? imageFile;
  final _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  void _createPost() async {
    String? image = imageFile == null ? null : getStringImage(imageFile);
    ApiResponse response = await createPost(postController.text, image);

    if (response.error == null) {
      Navigator.of(context).pop();
    } else if (response.error == unauthorized) {
      logout().then(
        (value) => {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Login()),
              (route) => false)
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
      setState(() {
        _loading = !_loading;
      });
    }
  }

  @override
  void initState() {
    if (widget.post != null) {
      postController.text = widget.post!.body ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Add New Post'.text.make(),
        backgroundColor: Colors.red,
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : ListView(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                  image: imageFile == null
                      ? null
                      : DecorationImage(
                          image: FileImage(
                            imageFile ?? File(''),
                          ),
                          fit: BoxFit.cover,
                        ),
                ),
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      getImage();
                    },
                    icon: Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(children: [
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 9,
                      controller: postController,
                      decoration:
                          kInputDecoration("Post", "Write something here..."),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Body is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    kSizedButton("POST", () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _loading = !_loading;
                        });
                        _createPost();
                      }
                    }),
                  ]),
                ),
              ),
            ]),
    );
  }
}
