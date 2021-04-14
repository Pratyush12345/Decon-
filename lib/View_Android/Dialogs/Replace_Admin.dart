import 'package:Decon/Controller/Services/Auth.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Replace_Admin extends StatefulWidget {
  final String cityCode;
  final String cityName;
  final String stateName;
  final String phoneNo;
  Replace_Admin({this.cityCode, this.cityName, this.stateName, this.phoneNo});
  @override
  _Replace_Admin createState() => _Replace_Admin();
}

class _Replace_Admin extends State<Replace_Admin> {
  final _phoneNoController = TextEditingController();
  final _nameController = TextEditingController();
  final _adminpostController = TextEditingController();

  String errorname = "", errorphoneno = "", errorpost = "";

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
        height: SizeConfig.screenHeight * 180 / 640,
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.b * 2.5,
        ),
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
                  Container(
                    width: SizeConfig.b * 45,
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
                    width: SizeConfig.b * 45,
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
                      keyboardType: TextInputType.phone,
                      controller: _phoneNoController,
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
                ]),
            SizedBox(
              width: SizeConfig.screenWidth * 120 / 360,
              child: MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  if (_phoneNoController.text == "") {
                    setState(() {
                      errorname = "Name is required";
                    });
                  } else {
                    errorname = "";
                    if (_adminpostController.text == "") {
                      setState(() {
                        errorpost = "Post is required";
                      });
                    } else {
                      errorpost = "";

                      if (_phoneNoController.text == "") {
                        setState(() {
                          errorphoneno = "Phone No required";
                        });
                      } else if (_phoneNoController.text.length != 10) {
                        setState(() {
                          errorphoneno = "Phone No should be of 10 digits";
                        });
                      } else {
                        FirebaseFirestore.instance
                            .collection('CurrentLogins')
                            .doc("+91${_phoneNoController.text}")
                            .set({
                          "value":
                              "Admin@${_adminpostController.text}_${widget.cityName}_${widget.cityCode}_None_${widget.stateName}"
                        });

                        DataSnapshot snapshot = await FirebaseDatabase.instance
                            .reference()
                            .child("/adminsList/")
                            .orderByChild("phoneNo")
                            .equalTo(widget.phoneNo)
                            .once();

                        Map _map = snapshot.value;

                        _map.forEach((key, value) {
                          FirebaseDatabase.instance
                              .reference()
                              .child("/adminsList/$key")
                              .remove();
                        });
                        FirebaseDatabase.instance
                            .reference()
                            .child("adminsList")
                            .push()
                            .update({
                          "name": _nameController.text,
                          "phoneNo": "+91${_phoneNoController.text}",
                          "post": "Admin@${_adminpostController.text}",
                          "cityName": widget.cityName,
                          "stateName": widget.stateName,
                          "cityCode": widget.cityCode,
                          "rangeOfDeviceEx": "None"
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
                child: Text(
                  'Replace',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.b * 4.2,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
