import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:Decon/Controller/ViewModels/add_client_viewmodel.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:Decon/Models/Models.dart';
import 'package:Decon/View_Android/DrawerFragments/managers_list.dart';
import 'package:flutter/material.dart';

class AddClient extends StatefulWidget {
  final String clientCode;
  final bool isedit;
  final UserDetailModel userDetailModel;
  AddClient({this.userDetailModel, @required this.clientCode, this.isedit });
  @override
  _AddClientState createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _departmentNameController = TextEditingController(text: "");
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _maintainencesheetController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  UserDetailModel _userDetailModel;
  UserDetailModel _previousUserDetailModel;
   void validate() async{
    if(_formKey.currentState.validate()){
                  if(AddClientVM.instance.selectedSeries == null || AddClientVM.instance.selectedSeries == ""){
                    AppConstant.showFailToast(context, "Please Select Series");
                  }
                  else if(_userDetailModel?.key == null || _userDetailModel.key == "" ){
                    AppConstant.showFailToast(context, "Please Select Manager");
                  }
                  else{
                  ClientListModel clientListModel = ClientListModel(
                        clientCode: widget.clientCode,
                        clientName: _nameController.text.trim()
                      );
                  ClientDetailModel model = ClientDetailModel(
                    cityName: _cityController.text.trim(),
                    clientName: _nameController.text.trim(),
                    departmentName: _departmentNameController.text.trim(),
                    districtName: _districtController.text.trim(),
                    selectedSeries: AddClientVM.instance.selectedSeries,
                    stateName: _stateController.text.trim(),
                    selectedManager: _userDetailModel.key,
                    selectedAdmin: AddClientVM.instance.clientDetailModel?.selectedAdmin??"",
                    maintainenceSheetURL: _maintainencesheetController.text.trim(),
                  );
                  AddClientVM.instance.onPressedDone(context, _previousUserDetailModel,_userDetailModel.clientsVisible, widget.isedit, model, clientListModel);       
                  }
           }
    else{
      print("Not Validated");
    }
  }

   _getSeriesWidget(){
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

     return Column(
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       children: AddClientVM.instance.seriesList.map((e) => 
       Column(
         children: [
           Row(children: [
             Text(e.seriesName),
             Spacer(),
             Checkbox(
               value: AddClientVM.instance.selectedSeries.contains(e.seriesName), 
               onChanged: (val){
                 if(val){
                 AddClientVM.instance.selectedSeries = AddClientVM.instance.selectedSeries + "," + e.seriesName.trim(); 
                 }
                 else{
                 AddClientVM.instance.selectedSeries = AddClientVM.instance.selectedSeries.replaceAll(","+e.seriesName.trim(), "");
                 }
                 
                 setState(() {});
             })
           ],),
           SizedBox(height: 15.0,),
           if(AddClientVM.instance.selectedSeries.contains(e.seriesName))
           TextFormField(
                validator: (val){
                            if(val.isEmpty)
                            return "Sheet URL Cannot be empty";
                            else
                            return null;
                          },
                controller: e.sheetController,
                decoration: InputDecoration(
                  fillColor: Color(0xfff6f6f6),
                 filled: true,
                 contentPadding:
                     EdgeInsets.symmetric(vertical: h * 8, horizontal: b * 8),
                 border: InputBorder.none,
                 focusedBorder: InputBorder.none,
                 enabledBorder: InputBorder.none,
                  
                 
                  hintText: "Enter Sheet URL",
                  hintStyle: TextStyle(
                   fontSize: b * 16,
                   color: Color(0xff858585),
                 ),
                ),
                
               maxLines: 1,
              ),
              
         ],
       )
       ).toList()
     );
   }
   _initializeData() async{
     if(!widget.isedit){
       AddClientVM.instance.init();
     }
     _userDetailModel = widget.userDetailModel;  
    _previousUserDetailModel = _userDetailModel;
    _nameController.text = AddClientVM.instance.clientDetailModel?.clientName;
    _departmentNameController.text = AddClientVM.instance.clientDetailModel?.departmentName;
    _cityController.text = AddClientVM.instance.clientDetailModel?.cityName;
    _districtController.text = AddClientVM.instance.clientDetailModel?.districtName;
    _stateController.text = AddClientVM.instance.clientDetailModel?.stateName;
    _maintainencesheetController.text = AddClientVM.instance.clientDetailModel?.maintainenceSheetURL;
    await AddClientVM.instance.getSeriesList(widget.isedit, widget.clientCode);
    setState(() {});
   }
  @override
    void initState() {
      _initializeData();
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Scaffold(
      appBar: AppBar(leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: blc, size: b * 16),
        ),
        elevation: 10,
        titleSpacing: -3,
        iconTheme: IconThemeData(color: blc),
        title: Text(
          "Add Client",
          style: txtS(Colors.black, 16, FontWeight.w500),
        ),
        actions: [
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(right: b * 20),
              height: h * 32,
              width: b * 32,
              decoration: BoxDecoration(
                color: blc,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: b * 16, vertical: b * 14),
        child: AddClientVM.instance.seriesList == null? AppConstant.circulerProgressIndicator():
          AddClientVM.instance.seriesList.isEmpty ? AppConstant.noDataFound():
          
          Form(
            key: _formKey,
             child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
             TextFormField(
               validator: (val){
                            if(val.isEmpty)
                            return "Name Cannot be empty";
                            else
                            return null;
                          },
                
               controller: _nameController,
              style: TextStyle(fontSize: b * 16, color: dc),
               decoration: InputDecoration(
                 fillColor: Color(0xfff6f6f6),
                 filled: true,
                          
                 isDense: true,
                 contentPadding:
                     EdgeInsets.symmetric(vertical: h * 8, horizontal: b * 8),
                 border: InputBorder.none,
                 focusedBorder: InputBorder.none,
                 hintText: "Enter name",
                 hintStyle: TextStyle(
                   fontSize: b * 16,
                   color: Color(0xff858585),
                 ),
                 enabledBorder: InputBorder.none,
               ),
               maxLines: 1,
             ),
            //   SizedBox(height: 15.0,),
            //   TextFormField(
            //    validator: (val){
            //                 if(val.isEmpty)
            //                 return "Department Name Cannot be empty";
            //                 else
            //                 return null;
            //               },
                
                
            //    controller: _departmentNameController,
            //   style: TextStyle(fontSize: b * 16, color: dc),
            //    decoration: InputDecoration(
            //      fillColor: Color(0xfff6f6f6),
            //      filled: true,
                          
            //      isDense: true,
            //      contentPadding:
            //          EdgeInsets.symmetric(vertical: h * 8, horizontal: b * 8),
            //      border: InputBorder.none,
            //      focusedBorder: InputBorder.none,
            //      hintText: "Enter Department Name",
            //      hintStyle: TextStyle(
            //        fontSize: b * 16,
            //        color: Color(0xff858585),
            //      ),
            //      enabledBorder: InputBorder.none,
            //    ),
            //    maxLines: 1,
            //  ),
              SizedBox(height: 15.0,),
              TextFormField(
               validator: (val){
                            if(val.isEmpty)
                            return "City Name Cannot be empty";
                            else
                            return null;
                          },
                 
               controller: _cityController,
              style: TextStyle(fontSize: b * 16, color: dc),
               decoration: InputDecoration(
                 fillColor: Color(0xfff6f6f6),
                 filled: true,
                          
                 isDense: true,
                 contentPadding:
                     EdgeInsets.symmetric(vertical: h * 8, horizontal: b * 8),
                 border: InputBorder.none,
                 focusedBorder: InputBorder.none,
                 hintText: "Enter City Name",
                 hintStyle: TextStyle(
                   fontSize: b * 16,
                   color: Color(0xff858585),
                 ),
                 enabledBorder: InputBorder.none,
               ),
               maxLines: 1,
             ),
              SizedBox(height: 15.0,),
              TextFormField(
                validator: (val){
                            if(val.isEmpty)
                            return "District name Cannot be empty";
                            else
                            return null;
                          },
                
                controller: _districtController,
                decoration: InputDecoration(
                  fillColor: Color(0xfff6f6f6),
                  filled: true,
                  contentPadding:
                     EdgeInsets.symmetric(vertical: h * 8, horizontal: b * 8),
                 border: InputBorder.none,
                 focusedBorder: InputBorder.none,
                 enabledBorder: InputBorder.none,
                  hintText: "Enter District",
                  hintStyle: TextStyle(
                   fontSize: b * 16,
                   color: Color(0xff858585),
                 ),
                ),
                
               maxLines: 1,
              ),
              SizedBox(height: 15.0,),
              TextFormField(
                validator: (val){
                            if(val.isEmpty)
                            return "State Name Cannot be empty";
                            else
                            return null;
                          },
                controller: _stateController,
                decoration: InputDecoration(
                  fillColor: Color(0xfff6f6f6),
                 filled: true,
                 contentPadding:
                     EdgeInsets.symmetric(vertical: h * 8, horizontal: b * 8),
                 border: InputBorder.none,
                 focusedBorder: InputBorder.none,
                 enabledBorder: InputBorder.none,
                  
                 
                  hintText: "Enter State",
                  hintStyle: TextStyle(
                   fontSize: b * 16,
                   color: Color(0xff858585),
                 ),
                ),
                
               maxLines: 1,
              ),
              SizedBox(height: 15.0,),
              
              TextFormField(
                validator: (val){
                            if(val.isEmpty)
                            return "Maintainence Sheet URL Cannot be empty";
                            else
                            return null;
                          },
                controller: _maintainencesheetController,
                decoration: InputDecoration(
                  fillColor: Color(0xfff6f6f6),
                 filled: true,
                 contentPadding:
                     EdgeInsets.symmetric(vertical: h * 8, horizontal: b * 8),
                 border: InputBorder.none,
                 focusedBorder: InputBorder.none,
                 enabledBorder: InputBorder.none,
                  
                 
                  hintText: "Enter Maintainence Sheet URL",
                  hintStyle: TextStyle(
                   fontSize: b * 16,
                   color: Color(0xff858585),
                 ),
                ),
                
               maxLines: 1,
              ),
              
              sh(10),
              Text(
                  "Select Series",
                  style: TextStyle(
                    fontSize: b * 16,
                    color: dc,
                    fontWeight: FontWeight.w500,
                  ),
                  ),
               sh(6),
              
              _getSeriesWidget(),
              SizedBox(height: 15.0,),
              if(_userDetailModel?.key !=null)
              Card(
                      child: ListTile(
                        leading: Container(
                                      height: h * 25,
                                      width: b * 25,
                                      decoration: BoxDecoration(
                                        color: Color(0xff6d6d6d),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                        title: Text("${_userDetailModel?.name}",
                        style: txtS(blc, 16, FontWeight.w400)),
                        subtitle: Text("${_userDetailModel?.phoneNo}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: txtS(dc, 14, FontWeight.w400)),
                        trailing: Container(
                          width: 100.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("${_userDetailModel?.clientsVisible?.replaceFirst(",", "")??""}"),
                              
                            ],
                          ),
                        ),
                    )
                    ),
              SizedBox(height: 10.0,),
              MaterialButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: blc,
              padding: EdgeInsets.symmetric(vertical: h * 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(b * 6),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ManagersList(managerUid: _userDetailModel?.key, clientName: _nameController.text.trim() ,))).
                  then((value){ 
                    if(value!=null)
                    _userDetailModel = value;
                    setState(() {});
                    } );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: h * 10),
                alignment: Alignment.center,
                child: Text(
                  _userDetailModel?.key ==null? "Select Manager for Client" : "Update Manager for Client" ,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: b * 16,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            
              SizedBox(height: 40.0,), 
              MaterialButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: blc,
              padding: EdgeInsets.symmetric(vertical: h * 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(b * 6),
              ),
              onPressed: () {
                validate();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: h * 10),
                alignment: Alignment.center,
                child: Text(
                  widget.isedit?"Update": "Done" ,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: b * 16,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
             
                    
          ],
        ),
           ),
      ),
    );
  }
}