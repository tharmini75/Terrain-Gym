import 'dart:ffi';
import 'dart:io';
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:images_picker/images_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io' as io;

import '../../main.dart';


class Add extends StatefulWidget {

  @override
  _AddState createState() => new _AddState();
}


class _AddState extends State<Add> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  File image;
  ProgressDialog pr;
  String link;
  var _firebaseRef = FirebaseDatabase().reference().child('Items');

  uploadFile() async {
    if (image == null) {
      Fluttertoast.showToast(msg: "No file was selected");
      pr.hide();
      return null;
    }
    firebase_storage.UploadTask uploadTask;

    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('store')
        .child('/${image.path.split('/').last}');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': image.path});

    if (kIsWeb) {
      uploadTask = ref.putData(await image.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(io.File(image.path), metadata);
    }
    link = await uploadTask.snapshot.ref.getDownloadURL();
  }

  Future addItem() async {
    try {
      _firebaseRef.push().set({
        "name": _nameController.text,
        "price": _priceController.text,
        "description": _descriptionController.text,
        "image": link,
      });

      Fluttertoast.showToast(msg: 'Item Added Successfully');
      pr.hide();
      setState(() {
        _nameController.text = "";
        _priceController.text = "";
        _descriptionController.text = "";
        image = null;
      });
      Navigator.of(context).pop();
    } catch (e) {
      pr.hide();
      print(e);
      Fluttertoast.showToast(msg:'Something Happened');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
    @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    pr = ProgressDialog(context, type: ProgressDialogType.Normal,
        isDismissible: false,
        showLogs: true);
    return  Scaffold(
        backgroundColor: primaryColor,
        resizeToAvoidBottomInset:false,
        extendBodyBehindAppBar: true,
        appBar:  AppBar(
            elevation: 0,
            toolbarHeight: size.height*0.08,
            backgroundColor: primaryColor,
            title: Text("Add Items",
                style: TextStyle(
                    color: primaryColorDark,
                    fontFamily: "ElMessiri",
                    fontSize: size.height*0.035)
            ),
            centerTitle: true,
        ),
        body:SafeArea(
            child:  Container(
                child:SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(height: size.height*0.05),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,5,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Item Image",
                                style: TextStyle(
                                    color: primaryColorDark,
                                    fontFamily: "SourceSans",
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: size.height*0.02),
                          width: size.width*0.9,
                          alignment: Alignment.center,
                          child:InkWell(
                            onTap: () async {
                              List<Media> res = await ImagesPicker.pick(
                                count: 1,
                                pickType: PickType.image,
                                // cropOpt: CropOption(aspectRatio: CropAspectRatio.wh1x2)
                              );
                              if (res != null) {
                                print(res.map((e) => e.path).toList());
                                setState(() {
                                  image = File(res[0].thumbPath.toString());
                                  uploadFile();
                                });
                              }
                            },
                            child: (image != null)?Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: Container(
                                  height: size.height*0.2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.file(
                                        File(image.path)
                                    ),
                                  ),
                                )
                            ):Container(
                              child: FaIcon(
                                  FontAwesomeIcons.image,
                                color: accentNewColor,
                                size: size.height*0.15,
                              ),
                            )
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,0,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Item Name",
                                style: TextStyle(
                                    color: primaryColorDark,
                                    fontFamily: "SourceSans",
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.9,
                          child: TextFormField(
                            controller: _nameController,
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                              hintText: "Item name",
                              hintStyle: TextStyle(fontSize: size.height*0.022,color: Colors.black26),
                              border: OutlineInputBorder(

                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide.none,
                                //borderSide: const BorderSide(),
                              ),
                              filled: true,
                              contentPadding:EdgeInsets.all(15.0),
                              fillColor:textFieldColor,
                            ),
                            style: TextStyle(
                                fontSize: size.height*0.023
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Item name can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,5,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Price",
                                style: TextStyle(
                                    color: primaryColorDark,
                                    fontFamily: "SourceSans",
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.9,
                          child: TextFormField(
                              controller: _priceController,
                              cursorColor: primaryColor,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Price",
                                hintStyle: TextStyle(fontSize: size.height*0.022,color: Colors.black26),
                                border: OutlineInputBorder(

                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide.none,
                                  //borderSide: const BorderSide(),
                                ),
                                filled: true,
                                contentPadding:EdgeInsets.all(15.0),
                                fillColor:textFieldColor,
                              ),
                              style: TextStyle(
                                  fontSize: size.height*0.023
                              ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Price can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(0.0,5,0.0,0.0),
                            width: size.width*0.9,
                            child:  Text("Description",
                                style: TextStyle(
                                    color: primaryColorDark,
                                    fontFamily: "SourceSans",
                                    fontSize: size.height*0.02)
                            )
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                          width: size.width * 0.9,
                          child: TextFormField(
                              controller: _descriptionController,
                              cursorColor: primaryColor,
                              keyboardType: TextInputType.text,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: "Description",
                                hintStyle: TextStyle(fontSize: size.height*0.022,height: 1,color: Colors.black26),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide.none,
                                  //borderSide: const BorderSide(),
                                ),
                                filled: true,
                                contentPadding:EdgeInsets.all(15.0),
                                fillColor:textFieldColor,
                                counterText: ""
                              ),
                              style: TextStyle(
                                  fontSize: size.height*0.023,
                                  height: 1
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Description number can\'t be empty';
                                }
                                return null;
                              },
                          ),
                        ),
                        Container(height: size.height*0.03),
                        Container(
                          width: size.width*0.9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: FlatButton(
                              padding: EdgeInsets.symmetric(vertical: size.height*0.02, horizontal: 40),
                              color: primaryColorDark,
                              onPressed: () async {
                                //close the keyboard before submitting the form
                                if (FocusScope.of(context).isFirstFocus) {
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                }
                                pr.update(message: "Please wait...");
                                //validate the add user form
                                if (_formKey.currentState.validate()) {
                                  if(image != null && link != null) {
                                    await pr.show();
                                    addItem();
                                  }else{
                                    Fluttertoast.showToast(msg: "Please select an image");
                                  }
                                }
                              },
                              child: Text(
                                "Add Item",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height*0.023),
                              ),
                            ),
                          ),
                        ),
                        Container(height: size.height*0.01),

                      ],
                    ),
                  ),
                )
            )
        )
    );

  }
}

