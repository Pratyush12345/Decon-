//city name
//state name
//name of admin
//mobile no


import 'package:Decon/Models/Models.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
class AddCity extends StatefulWidget {
  final cityLength;
  AddCity({@required this.cityLength});
  @override
  _AddCityState createState() => _AddCityState();
}

class _AddCityState extends State<AddCity> {

  final _cityNameController = TextEditingController();
  final dbRef = FirebaseDatabase.instance;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SingleChildScrollView(
         physics: ScrollPhysics(),
          child:  Card(
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
         padding: EdgeInsets.fromLTRB(SizeConfig.b * 2.5,
                      SizeConfig.v * 0.5, SizeConfig.b * 2.5, SizeConfig.v * 3),
                  
         child: Column(
             children: [
               Container(
                 alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(
                                SizeConfig.b * 5.09, 0, 0, 0),
                            width: SizeConfig.b * 80,
                  decoration: BoxDecoration(
                                color: Color(0xffDEE0E0),
                                borderRadius:
                                    BorderRadius.circular(SizeConfig.b * 2)),
                                      
                 child: TextField(
                      controller: _cityNameController,
                      style: TextStyle(
                        fontSize: 14.0,
                         color: Color(0xFF868A8F)
                      ),
                      
                      onChanged: null,
                      decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          hintText: "Enter City Name",
                          border: InputBorder.none 
                          ),
                    ),
               ),
                  SizedBox(height: 20.0),
                  
               ButtonTheme(
                   
                   child: MaterialButton(
                   shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                side: BorderSide(color: Colors.blue)),
                              
                   child: Text("Add"),
                   textColor: Colors.white,
                            elevation: 7.0,
                            color: Colors.blue,
                  onPressed: (){
                    dbRef.reference().child("citiesList").update({
                     "C${widget.cityLength}" : _cityNameController.text
                    });
                    
                          // dbRef.reference()
                          // .child("cities/C${widget.cityLength}/DeviceSettings")
                          // .update(S1DeviceSettingModel(
                          //         "4.0",
                          //         "1.0",
                          //         "2.0",
                          //         "3.0",
                          //         "3.0",
                          //         "50.0",
                          //         "20.0")
                          //     .toJson());
                            

                    Navigator.of(context).pop();
                  },
                 ),
               )
             ],
         ),
       ),
          ),
    );
  }
}

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double b;
  static double v;
  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    b = screenWidth / 100;
    v = screenHeight / 100;
  }
}
