import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterblogwithlaravel/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class PostForm extends StatefulWidget {
  const PostForm({Key? key}) : super(key: key);

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController postController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Add New Post'.text.make(),
        backgroundColor: Colors.red,
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
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
                      }
                    }),
                  ]),
                ),
              ),
            ]),
    );
  }
}
