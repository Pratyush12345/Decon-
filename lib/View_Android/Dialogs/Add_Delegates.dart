import 'package:Decon/Models/Models.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
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
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Card(
        margin: EdgeInsets.fromLTRB(
            SizeConfig.screenWidth * 0.05,
            SizeConfig.screenHeight * 0.2,
            SizeConfig.screenWidth * 0.05,
            SizeConfig.screenHeight * 0.21),
        elevation: 5,
        color: Color(0xff263238),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.b * 2.25),
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(SizeConfig.b * 2.5, SizeConfig.v * 0.5,
              SizeConfig.b * 2.5, SizeConfig.v * 3),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.v * 2.5),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Name",
                        style: TextStyle(
                            fontSize: SizeConfig.b * 4.07,
                            color: Colors.white)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding:
                              EdgeInsets.fromLTRB(SizeConfig.b * 5.09, 0, 0, 0),
                          width: SizeConfig.b * 50,
                          decoration: BoxDecoration(
                              color: Color(0xffDEE0E0),
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.b * 1)),
                          child: TextField(
                            keyboardType: TextInputType.text,
                            controller: _nameController,
                            style: TextStyle(fontSize: SizeConfig.b * 4.3),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Enter Name',
                              hintStyle: TextStyle(fontSize: SizeConfig.b * 4),
                              border: InputBorder.none,
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
              SizedBox(height: SizeConfig.v * 2),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Enter Post",
                        style: TextStyle(
                            fontSize: SizeConfig.b * 4.07,
                            color: Colors.white)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding:
                              EdgeInsets.fromLTRB(SizeConfig.b * 5.09, 0, 0, 0),
                          width: SizeConfig.b * 50,
                          decoration: BoxDecoration(
                              color: Color(0xffDEE0E0),
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.b * 1)),
                          child: TextField(
                            keyboardType: TextInputType.text,
                            controller: _postnameController,
                            style: TextStyle(fontSize: SizeConfig.b * 4.3),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Post',
                              hintStyle: TextStyle(fontSize: SizeConfig.b * 4),
                              border: InputBorder.none,
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
              SizedBox(height: SizeConfig.v * 2),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Mobile Number",
                        style: TextStyle(
                            fontSize: SizeConfig.b * 4.07,
                            color: Colors.white)),
                    Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.fromLTRB(SizeConfig.b * 5.09, 0, 0, 0),
                      width: SizeConfig.b * 50,
                      decoration: BoxDecoration(
                          color: Color(0xffDEE0E0),
                          borderRadius:
                              BorderRadius.circular(SizeConfig.b * 1)),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _phoneNumberController,
                        style: TextStyle(fontSize: SizeConfig.b * 4.3),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Enter Phone Number',
                          hintStyle: TextStyle(fontSize: SizeConfig.b * 4),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    if (errortextphoneno != "")
                      Text(
                        errortextphoneno,
                        style: TextStyle(fontSize: 12.0, color: Colors.red),
                      ),
                  ]),
              SizedBox(height: SizeConfig.v * 4),
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
                            } else if (_phoneNumberController.text.length !=
                                10) {
                              setState(() {
                                errortextphoneno =
                                    "Phone No should be of 10 digits";
                              });
                            } else {
                              String decideTeam = "managerTeam" ?? "adminTeam";
                              String decideuid;
                              String byWhome = "ByManager" ?? "ByAdmin";

                              FirebaseDatabase.instance
                                  .reference()
                                  .child(
                                      "$decideTeam/$decideuid")
                                  .push()
                                  .update({
                                "name": _nameController.text,
                                "phoneNo": "+91${_phoneNumberController.text}",
                                "post": "${_postnameController.text}@Vysion",
                                "clientsVisible": "C0,C1"
                              });
                              FirebaseFirestore.instance
                                  .collection('CurrentLogins')
                                  .doc("+91${_phoneNumberController.text}")
                                  .set({
                                "value":
                                    "${_postnameController.text}@Vysion_${byWhome}_$decideuid}"
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
      ),
    );
  }
}
