import 'package:Decon/Models/Models.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Add_admin extends StatefulWidget {
  final int cityLength;
  Add_admin({@required this.cityLength});
  @override
  _Add_admin createState() => _Add_admin();
}

class _Add_admin extends State<Add_admin> {
  final _phoneNumberController = TextEditingController();
  final _nameController = TextEditingController();
  final _adminpostController = TextEditingController();
  final _stateNameController = TextEditingController();
  final _cityNameController = TextEditingController();
  final _sheetURLController = TextEditingController();
  final dbRef = FirebaseDatabase.instance;
  String errorname = "",
      errorcityname = "",
      errorstatename = "",
      errorphoneno = "",
      errorpost = "",
      errorsheeturl = "";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Dialog(
      elevation: 4,
      backgroundColor: Color(0xff263238),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.b * 2.25),
      ),
      child: Container(
        height: SizeConfig.screenHeight * 280 / 640,
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 10 / 360),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: SizeConfig.b * 35,
                  height: SizeConfig.screenHeight * 30 / 640,
                  decoration: BoxDecoration(
                      color: Color(0xffDEE0E0),
                      borderRadius: BorderRadius.circular(SizeConfig.b * 1)),
                  child: TextField(
                    keyboardType: TextInputType.name,
                    controller: _cityNameController,
                    style: TextStyle(fontSize: SizeConfig.b * 4.3),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Color(0xffDEE0E0),
                      hintText: 'City Name',
                      hintStyle: TextStyle(fontSize: SizeConfig.b * 4),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(SizeConfig.b * 1)),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(SizeConfig.b * 1)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: SizeConfig.b * 35,
                  height: SizeConfig.screenHeight * 30 / 640,
                  decoration: BoxDecoration(
                      color: Color(0xffDEE0E0),
                      borderRadius: BorderRadius.circular(SizeConfig.b * 1)),
                  child: TextField(
                    keyboardType: TextInputType.name,
                    controller: _stateNameController,
                    style: TextStyle(fontSize: SizeConfig.b * 4.3),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Color(0xffDEE0E0),
                      hintText: 'State Name',
                      hintStyle: TextStyle(fontSize: SizeConfig.b * 4),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(SizeConfig.b * 1)),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(SizeConfig.b * 1)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Name of Admin",
                      style: TextStyle(
                          fontSize: SizeConfig.b * 4.07, color: Colors.white)),
                  Container(
                    width: SizeConfig.b * 40,
                    height: SizeConfig.screenHeight * 30 / 640,
                    decoration: BoxDecoration(
                        color: Color(0xffDEE0E0),
                        borderRadius: BorderRadius.circular(SizeConfig.b * 1)),
                    child: TextField(
                      keyboardType: TextInputType.name,
                      controller: _nameController,
                      style: TextStyle(fontSize: SizeConfig.b * 4.3),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Color(0xffDEE0E0),
                        hintText: 'Enter Name',
                        hintStyle: TextStyle(fontSize: SizeConfig.b * 4),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(SizeConfig.b * 1)),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(SizeConfig.b * 1)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ]),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Post",
                      style: TextStyle(
                          fontSize: SizeConfig.b * 4.07, color: Colors.white)),
                  Container(
                    width: SizeConfig.b * 40,
                    height: SizeConfig.screenHeight * 30 / 640,
                    decoration: BoxDecoration(
                        color: Color(0xffDEE0E0),
                        borderRadius: BorderRadius.circular(SizeConfig.b * 1)),
                    child: TextField(
                      keyboardType: TextInputType.name,
                      controller: _adminpostController,
                      style: TextStyle(fontSize: SizeConfig.b * 4.3),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Color(0xffDEE0E0),
                        hintText: 'Enter Post',
                        hintStyle: TextStyle(fontSize: SizeConfig.b * 4),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(SizeConfig.b * 1)),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(SizeConfig.b * 1)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ]),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sheet URL",
                      style: TextStyle(
                          fontSize: SizeConfig.b * 4.07, color: Colors.white)),
                  Container(
                    width: SizeConfig.b * 40,
                    height: SizeConfig.screenHeight * 30 / 640,
                    decoration: BoxDecoration(
                        color: Color(0xffDEE0E0),
                        borderRadius: BorderRadius.circular(SizeConfig.b * 1)),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: _sheetURLController,
                      style: TextStyle(fontSize: SizeConfig.b * 4.3),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Color(0xffDEE0E0),
                        hintText: 'Sheet URL',
                        hintStyle: TextStyle(fontSize: SizeConfig.b * 4),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(SizeConfig.b * 1)),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(SizeConfig.b * 1)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ]),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Mobile Number",
                    style: TextStyle(
                        fontSize: SizeConfig.b * 4.07, color: Colors.white)),
                Container(
                  width: SizeConfig.b * 40,
                  height: SizeConfig.screenHeight * 30 / 640,
                  decoration: BoxDecoration(
                      color: Color(0xffDEE0E0),
                      borderRadius: BorderRadius.circular(SizeConfig.b * 1)),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _phoneNumberController,
                    style: TextStyle(fontSize: SizeConfig.b * 4.3),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Color(0xffDEE0E0),
                      hintText: 'Enter Phone Number',
                      hintStyle: TextStyle(fontSize: SizeConfig.b * 4),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(SizeConfig.b * 1)),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(SizeConfig.b * 1)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 5 / 640,
            ),
            SizedBox(
                width: SizeConfig.screenWidth * 100 / 360,
                child: MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      if (_cityNameController.text == "") {
                        setState(() {
                          errorcityname = "City Name is required";
                        });
                      } else {
                        errorcityname = "";
                        if (_stateNameController.text == "") {
                          setState(() {
                            errorstatename = "State Name is required";
                          });
                        } else {
                          errorstatename = "";
                          if (_nameController.text == "") {
                            setState(() {
                              errorname = "Name is reuired";
                            });
                          } else {
                            errorname = "";
                            if (_adminpostController.text == "") {
                              setState(() {
                                errorpost = "Post is Required";
                              });
                            } else {
                              errorpost = "";
                              if (_sheetURLController.text == "") {
                                setState(() {
                                  errorsheeturl = "Sheet Url is required";
                                });
                              } else {
                                errorsheeturl = "";
                                if (_phoneNumberController.text == "") {
                                  setState(() {
                                    errorphoneno = "Phone No required";
                                  });
                                } else if (_phoneNumberController.text.length !=
                                    10) {
                                  setState(() {
                                    errorphoneno =
                                        "Phone No should be of 10 digits";
                                  });
                                } else {
                                  dbRef.reference().child("citiesList").update({
                                    "C${widget.cityLength}":
                                        _cityNameController.text
                                  });
                                  dbRef
                                      .reference()
                                      .child(
                                          "cities/C${widget.cityLength}/DeviceSettings")
                                      .update(DeviceSettingModel(
                                              "4.0",
                                              "1.0",
                                              "2.0",
                                              "3.0",
                                              "3.0",
                                              "50.0",
                                              "20.0")
                                          .toJson());
                                  dbRef
                                      .reference()
                                      .child("cities/C${widget.cityLength}")
                                      .update({
                                    "sheetURL": _sheetURLController.text,
                                    "stateName": _stateNameController.text,
                                  });
                                  dbRef
                                      .reference()
                                      .child("adminsList")
                                      .push()
                                      .update({
                                    "name": _nameController.text,
                                    "phoneNo":
                                        "+91${_phoneNumberController.text}",
                                    "post":
                                        "Admin@${_adminpostController.text}",
                                    "cityName": _cityNameController.text,
                                    "stateName": _stateNameController.text,
                                    "cityCode": "C${widget.cityLength}",
                                    "rangeOfDeviceEx": "None"
                                  });
                                  FirebaseFirestore.instance
                                      .collection('CurrentLogins')
                                      .doc("+91${_phoneNumberController.text}")
                                      .set({
                                    "value":
                                        "Admin@${_adminpostController.text}_${_cityNameController.text}_C${widget.cityLength}_None_${_stateNameController.text}"
                                  });
                                  Navigator.of(context).pop();
                                }
                              }
                            }
                          }
                        }
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Color(0xff00A3FF),
                    child: Text('ADD',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.b * 4.2,
                            fontWeight: FontWeight.w400)))),
          ],
        ),
      ),
    );
  }
}
