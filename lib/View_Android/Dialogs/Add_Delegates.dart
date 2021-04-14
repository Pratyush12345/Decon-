import 'package:Decon/Models/Models.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Add_Delegates extends StatefulWidget {
  DelegateModel delegateModel;
  Add_Delegates({@required this.delegateModel});
  @override
  _Add_Delegates createState() => _Add_Delegates();
}

class _Add_Delegates extends State<Add_Delegates> {
  final _phoneNumberController = TextEditingController();
  final _postnameController = TextEditingController();
  final _nameController = TextEditingController();
  String errortextname = "", errortextphoneno = "", errortextpostname = "";

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
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.b * 2.5),
        height: SizeConfig.screenHeight * 180 / 640,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Name",
                      style: TextStyle(
                          fontSize: SizeConfig.b * 4.07, color: Colors.white)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: SizeConfig.b * 45,
                        height: SizeConfig.screenHeight * 30 / 640,
                        decoration: BoxDecoration(
                            color: Color(0xffDEE0E0),
                            borderRadius:
                                BorderRadius.circular(SizeConfig.b * 1)),
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
                      if (errortextname != "")
                        Text(
                          errortextname,
                          style: TextStyle(fontSize: 12.0, color: Colors.red),
                        ),
                    ],
                  ),
                ]),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Post",
                      style: TextStyle(
                          fontSize: SizeConfig.b * 4.07, color: Colors.white)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: SizeConfig.b * 45,
                        height: SizeConfig.screenHeight * 30 / 640,
                        decoration: BoxDecoration(
                            color: Color(0xffDEE0E0),
                            borderRadius:
                                BorderRadius.circular(SizeConfig.b * 1)),
                        child: TextField(
                          keyboardType: TextInputType.name,
                          controller: _postnameController,
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
                      if (errortextpostname != "")
                        Text(
                          errortextpostname,
                          style: TextStyle(fontSize: 12.0, color: Colors.red),
                        ),
                    ],
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
                    width: SizeConfig.b * 45,
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
                        hintText: 'Enter Mobile Number',
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
                  if (errortextphoneno != "")
                    Text(
                      errortextphoneno,
                      style: TextStyle(fontSize: 12.0, color: Colors.red),
                    ),
                ]),
            SizedBox(
                width: SizeConfig.screenWidth * 100 / 360,
                child: MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      if (_nameController.text == "") {
                        setState(() {
                          errortextname = "Name is required";
                        });
                      } else {
                        errortextname = "";
                        if (_postnameController.text == "") {
                          setState(() {
                            errortextpostname = "Post is required";
                          });
                        } else {
                          errortextpostname = "";
                          if (_phoneNumberController.text == "") {
                            setState(() {
                              errortextphoneno = "Phone No required";
                            });
                          } else if (_phoneNumberController.text.length != 10) {
                            setState(() {
                              errortextphoneno =
                                  "Phone No should be of 10 digits";
                            });
                          } else {
                            FirebaseDatabase.instance
                                .reference()
                                .child(
                                    "cities/${widget.delegateModel.cityCode ?? "C0"}/posts")
                                .push()
                                .update({
                              "name": _nameController.text,
                              "phoneNo": "+91${_phoneNumberController.text}",
                              "post": "${_postnameController.text}@Vysion",
                              "cityName": "${widget.delegateModel.cityName}",
                              "stateName": "${widget.delegateModel.stateName}",
                              "rangeOfDeviceEx": "None"
                            });
                            FirebaseFirestore.instance
                                .collection('CurrentLogins')
                                .doc("+91${_phoneNumberController.text}")
                                .set({
                              "value":
                                  "${_postnameController.text}@Vysion_${widget.delegateModel.cityName}_${widget.delegateModel.cityCode}_None_${widget.delegateModel.stateName}"
                            });
                            Navigator.of(context).pop();
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
