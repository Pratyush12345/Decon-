import 'package:Decon/Models/AddressCaluclator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class Address extends StatefulWidget {
  double latitude, longitude;
  int battery;
  String devicename, status;
  Address(this.status, this.devicename, this.latitude, this.longitude,
      this.battery);
  @override
  State<StatefulWidget> createState() {
    return AddressState(status, devicename, latitude, longitude, battery);
  }
}

class AddressState extends State<Address> {
  double longitude, latitude;
  int battery;
  String devicename, status;
  String futureAddress = "";
  int flag = 0;
  Position position;
  AddressState(this.status, this.devicename, this.latitude, this.longitude,
      this.battery);

  Map<String, Color> statusColors = {
    "GROUND": Color.fromRGBO(227, 174, 230, 1),
    "NORMAL": Color.fromRGBO(208, 247, 183, 1),
    "INFORMATIVE": Color.fromRGBO(245, 240, 198, 1),
    "CRITICAL": Color.fromRGBO(240, 147, 144, 1)
  };
  Map<String, Color> iconColor = {
    "GROUND": Colors.purple,
    "NORMAL": Colors.green,
    "INFORMATIVE": Colors.yellow,
    "CRITICAL": Colors.red
  };

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    setState(() {
      position = res;
    });
  }

  Future getDistance(
      Position position, double latitude, double longitude) async {
    double distanceInMeters =  Geolocator.distanceBetween(
        position.latitude, position.longitude, latitude, longitude);
    return distanceInMeters;
  }

  showErrorDialog(BuildContext context, String error) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(error),
          );
        });
  }

  Future createAlertDialog(BuildContext context) {
    TextEditingController customController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter Password"),
            content: TextField(
              controller: customController,
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(customController.text.toString());
                },
                elevation: 5.0,
                child: Text("Submit"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Future<String> address =
        AddressCalculator(latitude, longitude).getLocation();
    if (flag == 0) {
      address.then((value) {
        setState(() {
          futureAddress = value;
          flag = 1;
          print(futureAddress);
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Address'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
                height: 200.0,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: statusColors[status],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: iconColor[status],
                    ),
                    title: Text(
                      futureAddress,
                      style: TextStyle(
                          fontSize: 23.0, fontWeight: FontWeight.w400),
                    ),
                  ),
                )),
          ),

          Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              height: 100.0,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: statusColors[status],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: ListTile(
                  leading: Icon(
                    Icons.battery_charging_full,
                    color: iconColor[status],
                  ),
                  title: Text(
                    battery.toString() + ".0 %",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: GestureDetector(
              onDoubleTap: () {
                try {
                  print("${position.latitude}, ${position.longitude}");
                  getDistance(position, latitude, longitude).then((distance) {
                    print("$distance");
                    if (distance <= 200.0) {
                      createAlertDialog(context).then((onValue) {
                        if (onValue == "123") {
                          final dbref = FirebaseDatabase.instance.reference();
                          dbref
                              .child("Jodhpur")
                              .child(devicename)
                              .update({"Battery": 100});
                        } else {
                          String error3 =
                              'error3';
                          showErrorDialog(context, error3);
                        }
                      });
                    } else {
                      String error2 = 'error2';
                      showErrorDialog(context, error2);
                    }
                  });
                } catch (e) {
                  String error1 = 'error1';
                  showErrorDialog(context, error1);
                }
              },
              child: Container(
                height: 80.0,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: statusColors[status],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: ListTile(
                    leading: Icon(
                      Icons.refresh,
                      color: iconColor[status],
                    ),
                    title: Text(
                      'resetbattery',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // child:ListTile(
          //   leading:Icon(Icons.refresh,color: Colors.purple,),

          // ),
        ],
      ),
    );
  }
}
