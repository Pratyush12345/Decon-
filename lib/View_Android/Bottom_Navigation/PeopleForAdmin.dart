import 'package:Decon/View_Android/Dialogs/Add_Delegates.dart';
import 'package:Decon/Models/Models.dart';
import 'package:Decon/Controller/Services/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:flutter/material.dart';

class PeopleForAdmin extends StatefulWidget {
  final BuildContext menuScreenContext;
  final bool fromManager;
  final String cityCode;
  PeopleForAdmin(
      {Key key, this.menuScreenContext, this.fromManager, this.cityCode})
      : super(key: key);

  @override
  _PeopleForAdmin createState() => _PeopleForAdmin();
}

const gc = Colors.black;
const tc = Color(0xff263238);

class _PeopleForAdmin extends State<PeopleForAdmin> {
  DelegateModel _delegateModel;
  String ccode;
  bool _teamSearchBar = false;
  _loadFromDatabase() async {
    try {
      DataSnapshot snapshot = await FirebaseDatabase.instance
          .reference()
          .child("adminsList")
          .orderByChild("cityCode")
          .equalTo("${ccode ?? "C0"}")
          .once();
      setState(() {
        _delegateModel = DelegateModel.fromJsonForAdmin(snapshot?.value);
      });
    } catch (e) {
      setState(() {
        _delegateModel = DelegateModel(
            cityCode: "C0",
            cityName: "Demo City",
            name: "Mr. Decon",
            numb: "91123456789",
            post: "Admin@Admin",
            rangeOfDeviceEx: {},
            stateName: "Demo State",
            uid: "123456789");
      });
    }
  }

  @override
  void initState() {
    if (widget.fromManager) {
      ccode = widget.cityCode;
    } else {
      ccode = Auth.instance.cityCode;
    }
    _loadFromDatabase();
    super.initState();
  }

  Future showDelegatesDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return Add_Delegates(delegateModel: _delegateModel);
        });
  }

  Future showDeleteDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text('Delete user?'), actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop("Yes");
              },
              elevation: 5.0,
              child: Text('YES'),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop("No");
              },
              elevation: 5.0,
              child: Text('NO'),
            )
          ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: widget.fromManager
          ? AppBar(
              title: Text(
                "Admin Team",
                style: TextStyle(color: Color(0xff263832)),
              ),
              backgroundColor: Colors.white,
              elevation: 2,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Color(0xff263832),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          : PreferredSize(
              preferredSize: Size.fromHeight(0.0),
              child: SizedBox(
                height: 0.0,
              ),
            ),
      floatingActionButton: Auth.instance.post == "Admin" || widget.fromManager
          ? FloatingActionButton(
              backgroundColor: Color(0xff0099FF),
              elevation: 2,
              onPressed: () {
                showDelegatesDialog(context);
              },
              child: Icon(
                Icons.add,
              ),
            )
          : SizedBox(
              height: 0.0,
            ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.v * 3),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              SizedBox(width: SizeConfig.b * 5),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: SizeConfig.b * 45.81,
                      child: Text(
                        "${_delegateModel?.name ?? Auth.instance.displayName}",
                        style: TextStyle(
                            fontSize: SizeConfig.b * 5.1,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      _delegateModel?.post != null
                          ? "${_delegateModel?.post?.split("@")[1]}"
                          : Auth.instance.post,
                      style: TextStyle(fontSize: SizeConfig.b * 3.56),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 4 / 640,
                    ),
                    Row(
                      children: [
                        Container(
                            height: SizeConfig.b * 5,
                            width: SizeConfig.b * 5,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(SizeConfig.b * 1.2),
                                color: Color(0x804ADB58)),
                            child: IconButton(
                                onPressed: null,
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.call,
                                    color: Colors.white,
                                    size: SizeConfig.b * 3.5))),
                        SizedBox(width: SizeConfig.b * 3),
                        Text(
                            "${_delegateModel?.numb ?? FirebaseAuth.instance.currentUser.phoneNumber}",
                            style: TextStyle(fontSize: SizeConfig.b * 3.56)),
                      ],
                    )
                  ],
                ),
              ),
              Spacer(),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${_delegateModel?.cityName ?? ""}",
                      style: TextStyle(
                          fontSize: SizeConfig.screenHeight * 12 / 640,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "${_delegateModel?.stateName ?? ""}",
                      style: TextStyle(
                          fontSize: SizeConfig.screenHeight * 12 / 640,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              SizedBox(width: SizeConfig.b * 5),
            ]),
            SizedBox(height: SizeConfig.v * 2),
            Divider(
              color: Colors.black,
              thickness: 0.4,
              indent: 15,
              endIndent: 15,
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight * 10 / 640,
                    ),
                    Row(
                      mainAxisAlignment: _teamSearchBar
                          ? MainAxisAlignment.spaceAround
                          : MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        _teamSearchBar
                            ? Container(
                                width: SizeConfig.screenWidth * 320 / 360,
                                height: SizeConfig.screenHeight * 30 / 640,
                                child: TextField(
                                  style:
                                      TextStyle(fontSize: SizeConfig.b * 4.3),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.search_rounded,
                                      size: 20,
                                    ),
                                    isDense: true,
                                    filled: true,
                                    fillColor: Color(0xffDEE0E0),
                                    hintText: 'Search by Name / Contact',
                                    hintStyle:
                                        TextStyle(fontSize: SizeConfig.b * 4),
                                    border: InputBorder.none,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(SizeConfig.b * 1.1)),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(SizeConfig.b * 1.1)),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.only(
                                  right: SizeConfig.b * 5.1,
                                ),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.search_rounded,
                                      color: Color(0xff263238),
                                      size: SizeConfig.screenHeight * 22 / 640,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _teamSearchBar = !_teamSearchBar;
                                      });
                                    }),
                              ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.v * 2),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: StreamBuilder<Event>(
                          stream: FirebaseDatabase.instance
                              .reference()
                              .child("cities/${ccode ?? "C0"}/posts")
                              .onValue,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<DelegateModel> _listofdelegates = [];

                              List<String> _pendingRequestDelegates = Auth
                                  .instance.pref
                                  .getStringList("pendingDelegatesRequest");

                              snapshot.data.snapshot?.value
                                  ?.forEach((key, value) {
                                Map _map = {};
                                String rangeofDevices =
                                    value["rangeOfDeviceEx"];
                                if (rangeofDevices != "None" &&
                                    rangeofDevices != null)
                                  rangeofDevices
                                      .replaceAll("{", "")
                                      .replaceAll("}", "")
                                      .split(",")
                                      .forEach((element) {
                                    String key = element.split(":")[0];
                                    String val = element.split(":")[1];
                                    _map[key] = val;
                                  });
                                _pendingRequestDelegates
                                    ?.remove(value["phoneNo"].toString());
                                _listofdelegates.add(DelegateModel(
                                    uid: key,
                                    stateName: value["stateName"],
                                    rangeOfDeviceEx: _map,
                                    cityName: value["cityName"],
                                    numb: value["phoneNo"],
                                    post: value["post"],
                                    name: value["name"]));
                              });
                              return ListView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: _listofdelegates.length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    return InkWell(
                                      onLongPress: () {
                                        showDeleteDialog(context)
                                            .then((value) async {
                                          print(value);
                                          if (value == "Yes") {
                                            DataSnapshot snapshot =
                                                await FirebaseDatabase.instance
                                                    .reference()
                                                    .child(
                                                        "/cities/${ccode ?? "C0"}/posts/")
                                                    .orderByChild("phoneNo")
                                                    .equalTo(
                                                        _listofdelegates[index]
                                                            .numb)
                                                    .once();
                                            Map _map = snapshot.value;
                                            _map.forEach((key, value) {
                                              FirebaseDatabase.instance
                                                  .reference()
                                                  .child(
                                                      "/cities/${ccode ?? "C0"}/posts/$key")
                                                  .remove();
                                            });
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            SizeConfig.b * 5.1,
                                            SizeConfig.v * 1,
                                            SizeConfig.b * 5.1,
                                            0),
                                        child: Material(
                                          color: Color(0xffececec),
                                          elevation: 2,
                                          borderRadius: BorderRadius.circular(
                                              SizeConfig.b * 1.2),
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                SizeConfig.b * 5.1,
                                                SizeConfig.v * 1,
                                                SizeConfig.b * 5.1,
                                                SizeConfig.v * 1),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _listofdelegates[index]
                                                          .name,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize:
                                                              SizeConfig.b *
                                                                  4.4,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Text(
                                                      _listofdelegates[index]
                                                          .post,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize:
                                                              SizeConfig.b *
                                                                  3.2),
                                                    ),
                                                    Text(
                                                      _listofdelegates[index]
                                                          .numb,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize:
                                                              SizeConfig.b *
                                                                  3.2),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            SizeConfig.b * 1.2),
                                                    color: Color(0x804ADB58),
                                                  ),
                                                  height: SizeConfig.v * 3.5,
                                                  width: SizeConfig.v * 3.5,
                                                  child: IconButton(
                                                    onPressed: null,
                                                    padding: EdgeInsets.zero,
                                                    icon: Icon(Icons.call,
                                                        color: Colors.white,
                                                        size: SizeConfig.b * 4),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            } else {
                              return Center(
                                child: Text('${snapshot.error}'),
                              );
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
