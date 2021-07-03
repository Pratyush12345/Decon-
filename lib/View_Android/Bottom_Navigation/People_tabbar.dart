import 'dart:async';

import 'package:Decon/Controller/Providers/People_provider.dart';
import 'package:Decon/Controller/ViewModels/people_viewmodel.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:Decon/View_Android/Bottom_Navigation/All_people.dart';
import 'package:Decon/View_Android/Dialogs/Add_Admin.dart';
import 'package:Decon/View_Android/Dialogs/Add_Manager.dart';
import 'package:Decon/View_Android/Dialogs/Replace_Admin.dart';
import 'package:Decon/Models/Models.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:Decon/Controller/ViewModels/Services/Auth.dart';
import 'package:Decon/View_Android/Dialogs/Replace_Manager.dart';
import 'package:Decon/View_Android/Dialogs/update_dialog.dart';
import 'package:Decon/View_Android/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';


class PeopleTabBar extends StatefulWidget {
  final BuildContext menuScreenContext;
  PeopleTabBar({Key key, this.menuScreenContext}) : super(key: key);

  @override
  _PeopleTabBar createState() => _PeopleTabBar();
}


class _PeopleTabBar extends State<PeopleTabBar> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<UserDetailModel> _listUserDetailModelAdmins = [];
  Map<String ,ClientDetailModel> _listClientDetailModel = {};
  List<UserDetailModel> _listUserDetailModelManager;
  TextEditingController _managerSearch = TextEditingController();
  TextEditingController _adminSearch = TextEditingController();
  @override
  void initState() {
    super.initState();
    PeopleVM.instance.init();
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  } 

  
  Future showManagerDialog(BuildContext context) {
    return showAnimatedDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return Add_man(list: _listUserDetailModelManager??[],);
        },   
        animationType: DialogTransitionType.scaleRotate,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 400),);
  }

  Future showAdminDialog(BuildContext context) {
    return showAnimatedDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return Add_admin(list: _listUserDetailModelAdmins??[],);
        },
        animationType: DialogTransitionType.scaleRotate,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 400),);
  }

  Future showReplaceAdminDialog(BuildContext context, String clientVisible, String uid) {
    return showAnimatedDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return Replace_Admin(
            clientVisible: clientVisible ,
            uid: uid,
            list: _listUserDetailModelAdmins,
          );
        },
        animationType: DialogTransitionType.scaleRotate,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 400),);
  }
  
  Future showReplaceManagerDialog(BuildContext context, String clientVisible, String uid) {
    return showAnimatedDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return Replace_Manager(
            clientVisible: clientVisible ,
            uid: uid,
            list: _listUserDetailModelManager,
          );
        },     
        animationType: DialogTransitionType.scaleRotate,
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 400),);
  }
  _getClientDetail(String clientCode, String uid) async{
   ClientDetailModel clientDetailModel = await PeopleVM.instance.getClientDetail(clientCode);
   _listClientDetailModel[uid] = (clientDetailModel);
   Provider.of<PeopleProvider>(context, listen: false).changeClientDetail(_listClientDetailModel);

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
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          TabBar(
              indicatorWeight: 2,
              indicatorColor: Color(0xff0099FF),
              labelPadding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.b * 0.76, vertical: 0),
              controller: _tabController,
              tabs: [
                Tab(
                  child: Text(
                    'Managers',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.b * 5.09,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Tab(
                  child: Text(
                    'Admins',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.b * 5.09,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ]),
          Expanded(
              flex: 2,
              child:
                  new TabBarView(controller: _tabController, children: <Widget>[
                Scaffold(
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: Color(0xff0099FF),
                    onPressed: () {
                      showManagerDialog(context);
                    },
                    child: SvgPicture.asset(
                      'images/AddUser.svg',
                      allowDrawingOutsideViewBox: true,
                    ),
                  ),
                  body: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(height: SizeConfig.v * 2),
                          Container(
                            alignment: Alignment.center,
                            width: b * 340,
                            decoration: BoxDecoration(
                              border: Border.all(color: dc, width: 0.5),
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(b * 60),
                            ),
                            child: TextField(
                              controller: _managerSearch,
                              onChanged: (val){
                                _listUserDetailModelManager = PeopleVM.instance.onSearchManager(val);
                                setState(() {});
                              },
                              style: TextStyle(fontSize: b * 14, color: dc),
                              decoration: InputDecoration(
                                prefixIcon: InkWell(
                                  child: Icon(Icons.search, color: Colors.black),
                                  onTap: null,
                                ),
                                isDense: true,
                                isCollapsed: true,
                                prefixIconConstraints:
                                    BoxConstraints(minWidth: 40, maxHeight: 24),
                                hintText: 'Search by Name/PhoneNo',
                                hintStyle: TextStyle(
                                  fontSize: b * 14,
                                  color: Color(0xff858585),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: h * 12, horizontal: b * 13),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
             
                          SizedBox(height: SizeConfig.v * 3),
                          Expanded(
                              child: SingleChildScrollView(
                                  physics: ScrollPhysics(),
                                  child: StreamBuilder<Event>(
                                      stream: FirebaseDatabase.instance.reference().child("managers").onValue,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          Map datamap = snapshot.data.snapshot.value;
                                          if(!PeopleVM.instance.isManagerSearched){
                                          _listUserDetailModelManager = [];
                                          datamap?.forEach((key, value) {  
                                            _listUserDetailModelManager.add(UserDetailModel.fromJson(key.toString(), value));
                                          });
                                          PeopleVM.instance.setManagerList = _listUserDetailModelManager;
                                          }
                                          if(snapshot.data.snapshot.value!=null)
              
                                          return ListView.builder(
                                              physics: ScrollPhysics(),
                                              shrinkWrap: true,
                                              padding: EdgeInsets.only(top: h * 10, left: 16.0, right: 16.0),
                                              itemCount: _listUserDetailModelManager.length,
                                              itemBuilder: (BuildContext ctxt,
                                                  int index) {
                                                return InkWell(
                                                  onTap: (){
                                                     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Profile(myProfile: false, userDetailModel: _listUserDetailModelManager[index], )));
                                                  },
                                                  onLongPress: () 
                                                    {
                                                    showReplaceManagerDialog(
                                                        context,
                                                        _listUserDetailModelManager[index].clientsVisible,
                                                        _listUserDetailModelManager[index].key,
                                                        );
                                                  },
                                                    child: Container(
                                                      margin: EdgeInsets.only(bottom: h * 8),
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: h * 13, horizontal: b * 0),
                                                      decoration: BoxDecoration(
                                                        color: Color(0xfff1f1f1),
                                                        borderRadius: BorderRadius.circular(b * 10),
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                              height: h * 50,
                                                              width: b * 50,
                                                              decoration: BoxDecoration(
                                                                color: Color(0xff6d6d6d),
                                                                shape: BoxShape.circle,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 7,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  _listUserDetailModelManager[index].name,
                                                                  style: txtS(blc, 16, FontWeight.w400),
                                                                ),
                                                                Text(
                                                                  _listUserDetailModelManager[index].phoneNo,
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: txtS(dc, 14, FontWeight.w400),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );

                                               });
                                          else
                                            return AppConstant.noDataFound();     

                                        } else {
                                          if(snapshot.hasError)
                                            return Center(
                                                  child: Text('${snapshot.error}'),
                                                );
                                            else
                                            return AppConstant.circulerProgressIndicator();   
                                        }
                                      }))),
                        ],
                      )),
                ),
                Scaffold(
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: Color(0xff0099FF),
                    onPressed: () {
                      showAdminDialog(context);
                    },
                    child: SvgPicture.asset(
                      'images/AddUser.svg',
                      allowDrawingOutsideViewBox: true,
                    ),
                  ),
                  body: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(height: SizeConfig.v * 2),
                          Container(
                            alignment: Alignment.center,
                            width: b * 340,
                            decoration: BoxDecoration(
                              border: Border.all(color: dc, width: 0.5),
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(b * 60),
                            ),
                            child: TextField(
                              controller: _adminSearch,
                              onChanged: (val){
                                _listUserDetailModelAdmins = PeopleVM.instance.onSearchAdmin(val);
                                setState(() {});
                              },
                              style: TextStyle(fontSize: b * 14, color: dc),
                              decoration: InputDecoration(
                                prefixIcon: InkWell(
                                  child: Icon(Icons.search, color: Colors.black),
                                  onTap: null,
                                ),
                                isDense: true,
                                isCollapsed: true,
                                prefixIconConstraints:
                                    BoxConstraints(minWidth: 40, maxHeight: 24),
                                hintText: 'Search by Name/Phone No',
                                hintStyle: TextStyle(
                                  fontSize: b * 14,
                                  color: Color(0xff858585),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: h * 12, horizontal: b * 13),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
             
                          SizedBox(height: SizeConfig.v * 3),
                          Expanded(
                              child: SingleChildScrollView(
                                  physics: ScrollPhysics(),
                                  child: StreamBuilder<Event>(
                                      stream: FirebaseDatabase.instance.reference().child("admins").onValue,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          Map datamap = snapshot.data.snapshot.value;
                                          if(!PeopleVM.instance.isAdminSearched){
                                          _listUserDetailModelAdmins = [];
                                          datamap?.forEach((key, value) {
                                            UserDetailModel userDetailModel = UserDetailModel.fromJson(key.toString(), value); 
                                            _listUserDetailModelAdmins.add(userDetailModel);
                                          PeopleVM.instance.setAdminList = _listUserDetailModelAdmins;  
                                          _getClientDetail(userDetailModel.clientsVisible, userDetailModel.key);
                                          });
                                          }

                                        if(snapshot.data.snapshot.value!=null)
                                          
                                          return ListView.builder(
                                              physics: ScrollPhysics(),
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              itemCount: _listUserDetailModelAdmins.length,
                                              itemBuilder: (BuildContext ctxt,
                                                  int index) {
                                                return Consumer<PeopleProvider>(
                                                                builder: (context, model, child)=>(
                                                  InkWell(
                                                  
                                                    onLongPress: () {
                                                      showReplaceAdminDialog(
                                                          context,
                                                          _listUserDetailModelAdmins[index].clientsVisible,
                                                          _listUserDetailModelAdmins[index].key,
                                                          );
                                                    },
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              AllPeople(
                                                            clientCode:_listUserDetailModelAdmins[index].clientsVisible,
                                                            clientDetailModel: model.listClientDetailModel[_listUserDetailModelAdmins[index].key],
                                                                
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                        color: Color(0xfff1f1f1),
                                                        borderRadius: BorderRadius.circular(b * 10),
                                                      ),
                                                          
                                                          margin: EdgeInsets.fromLTRB(SizeConfig.b *5.1,1,SizeConfig.b *5.1,1),
                                                          padding:EdgeInsets.fromLTRB(
                                                                  SizeConfig.b *5.1,
                                                                  SizeConfig.v *1,
                                                                  SizeConfig.b * 5.1,
                                                                  SizeConfig.v *1),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 2,
                                                                child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Container(
                                                                        width: SizeConfig.b *40.72,
                                                                        child:
                                                                            Text(_listUserDetailModelAdmins[index].name,
                                                                          style: txtS(blc, 16, FontWeight.w400),
                                                                        ),
                                                                      ),
                                                                      SizedBox(height:SizeConfig.v *1),
                                                                      Text(_listUserDetailModelAdmins[index].delegate,
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize: SizeConfig.b *3.1,
                                                                            fontWeight: FontWeight.w500),
                                                                      ),
                                                                      SizedBox(height:SizeConfig.v *1),
                                                                      Row(
                                                                          children: [
                                                                            Container(
                                                                              height:SizeConfig.v * 2.572,
                                                                               width: SizeConfig.b * 4.58,
                                                                              child:
                                                                                  IconButton(
                                                                                onPressed: null,
                                                                                padding: EdgeInsets.zero,
                                                                                icon: Icon(Icons.call, color: Colors.green, size: SizeConfig.b * 4),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                                width: SizeConfig.b * 2),
                                                                            Text(
                                                                              _listUserDetailModelAdmins[index].phoneNo,
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: txtS(dc, 14, FontWeight.w400)
                                                                              
                                                                            ),
                                                                          ]),
                                                                    ]),
                                                              ),
                                                              Spacer(),
                                                              Expanded(
                                                                flex: 1,
                                                                child: 
                                                                   Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                      children: [
                                                                        Text("${model.listClientDetailModel[_listUserDetailModelAdmins[index].key]?.cityName??"Loading..."}",
                                                                          style:TextStyle(
                                                                            color: Colors.black,
                                                                            fontSize: SizeConfig.b *4.1,
                                                                            fontWeight: FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: SizeConfig.v *1),
                                                                        Text("${model.listClientDetailModel[_listUserDetailModelAdmins[index].key]?.stateName??""}",
                                                                            style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: SizeConfig.b * 3.0)),
                                                                      ]),
                                                                ),
                                                              
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: SizeConfig.v * 1),
                                                      ],
                                                    ),
                                                  )
                                                                )
                                                );
                                              });
                                              else
                                               return AppConstant.noDataFound();     

                                        } else {
                                          if(snapshot.hasError)
                                            return Center(
                                                  child: Text('${snapshot.error}'),
                                                );
                                            else
                                            return AppConstant.circulerProgressIndicator();   
                                        }
                                      })))
                        ],
                      )),
                ),
              ])),
        ],
      ),
    );
  }
}
