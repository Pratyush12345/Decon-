import 'package:Decon/View_Android/Authentication/EnterOtp.dart';
import 'package:Decon/Controller/Services/Auth.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Add_man extends StatefulWidget {
  @override
  _Add_man createState() => _Add_man();
}

class _Add_man extends State<Add_man> {
  final _phoneNoController = TextEditingController();
  final _nameController = TextEditingController();
  String errortextphoneno = "";
  String errortextname = "";

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
        padding: EdgeInsets.fromLTRB(
          SizeConfig.b * 2.5,
          0,
          SizeConfig.b * 2.5,
          0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: SizeConfig.screenHeight * 15 / 640,
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Name",
                    style: TextStyle(
                        fontSize: SizeConfig.b * 4.07, color: Colors.white),
                  ),
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
            SizedBox(
              height: SizeConfig.screenHeight * 10 / 640,
            ),
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
                      controller: _phoneNoController,
                      style: TextStyle(fontSize: SizeConfig.b * 4.3),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Color(0xffDEE0E0),
                        hintText: 'Enter Phone Number',
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
              height: SizeConfig.screenHeight * 10 / 640,
            ),
            SizedBox(
              width: SizeConfig.screenWidth * 100 / 360,
              child: MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  if (_nameController.text == "") {
                    setState(() {
                      errortextname = "Name is reqiured";
                    });
                  } else {
                    errortextname = "";
                    if (_phoneNoController.text == "") {
                      setState(() {
                        errortextphoneno = "Phone No required";
                      });
                    } else if (_phoneNoController.text.length != 10) {
                      setState(() {
                        errortextphoneno = "Phone No should be of 10 digits";
                      });
                    } else {
                      FirebaseDatabase.instance
                          .reference()
                          .child("managerList")
                          .push()
                          .update({
                        "name": _nameController.text,
                        "phoneNo": "+91${_phoneNoController.text}",
                        "post": "Manager@Vysion",
                        "cityName": "Vysion",
                        "stateName": "Vysion",
                        "cityCode": "Vysion",
                        "rangeOfDeviceEx": "None"
                      });
                      FirebaseFirestore.instance
                          .collection('CurrentLogins')
                          .doc("+91${_phoneNoController.text}")
                          .set({
                        "value": "Manager@Vysion_Vysion_Vysion_None_Vysion"
                      });
                      Navigator.of(context).pop();
                    }
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Color(0xff00A3FF),
                child: Text(
                  'ADD',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.b * 4.2,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 15 / 640,
            ),
          ],
        ),
      ),
    );
  }
}
