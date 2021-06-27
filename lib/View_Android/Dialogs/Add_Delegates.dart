import 'package:Decon/Controller/ViewModels/Services/GlobalVariable.dart';
import 'package:Decon/Controller/ViewModels/dialog_viewmodel.dart';
import 'package:Decon/Controller/ViewModels/home_page_viewmodel.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:Decon/Models/Models.dart';
import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Add_Delegates extends StatefulWidget {
  final List<UserDetailModel> list;
  final UserDetailModel adminDetail;
  Add_Delegates({@required this.list, @required this.adminDetail});
  @override
  _Add_Delegates createState() => _Add_Delegates();
}


class _Add_Delegates extends State<Add_Delegates> {

  final _phoneNumberController = TextEditingController();
  final _postnameController = TextEditingController();
  final _nameController = TextEditingController();
  final _clientController = TextEditingController();
  
  bool admin = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  void validateTeamMember(){
    if(_formKey.currentState.validate()){
       DialogVM.instance.onAddDelegatePressed(context, _nameController.text.trim(), _postnameController.text.trim(), _phoneNumberController.text.trim());
        }
    else{
      print("Not Validated");
    }
  }

  void validateAddAdmin(){
    if(_formKey.currentState.validate()){
       DialogVM.instance.onAddAdminPressed(context,  _nameController.text.trim(), _phoneNumberController.text.trim(), _phoneNumberController.text.trim(), 
       _clientController.text.trim());
        }
    else{
      print("Not Validated");
    }
  }

  void validateReplaceAdmin(){
    if(_formKey.currentState.validate()){
       DialogVM.instance.onReplaceAdminPressed(context, _nameController.text.trim(), widget.adminDetail.clientsVisible, _phoneNumberController.text.trim(), 
       _postnameController.text.trim(), widget.adminDetail.key);
        }
    else{
      print("Not Validated");
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 375;
    var h = SizeConfig.screenHeight / 812;
    
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal:  b * 25,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular( b * 9),
      ),
      
      child: Container(
        padding: EdgeInsets.fromLTRB(b * 13, h * 16, b * 13, h * 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular( b * 9)
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
               Row(
              children: [
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        admin = !admin;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: h * 6),
                      decoration: BoxDecoration(
                        color: !admin ? blc : Colors.white,
                        border: Border.all(
                            color: admin ? blc : Colors.transparent,
                            width: b * 1),
                        borderRadius: BorderRadius.circular(b * 12),
                      ),
                      child: Text(
                        'Add team member',
                        style: TextStyle(
                          color: !admin ? Colors.white : blc,
                          fontSize: b * 11.63,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: b * 16),
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        admin = !admin;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: h * 6),
                      decoration: BoxDecoration(
                        color: admin ? blc : Colors.white,
                        border: Border.all(
                            color: !admin ? blc : Colors.transparent,
                            width: b * 1),
                        borderRadius: BorderRadius.circular(b * 12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.adminDetail.key!=null? 'Replace Admin' :'Add Admin',
                        style: TextStyle(
                          color: !admin ? blc : Colors.white,
                          fontSize: b * 11.63,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if(admin && widget.adminDetail.key == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                sh(6),
              Text(
                  "Client Code",
                  style: TextStyle(
                    fontSize: b * 16,
                    color: dc,
                    fontWeight: FontWeight.w500,
                  ),
                  ),
              sh(6),
              TextFormField(
                        validator: (val){
                        int index = widget.list.indexWhere((element) =>element.clientsVisible.contains(val) );
                        
                        if(val.isEmpty)
                        return "Client Code Cannot be empty";
                        else if(GlobalVar.strAccessLevel == "2" && !GlobalVar.userDetail.clientsVisible.contains(val))
                        return "Client Code not assigned";
                        else if(index!=-1)
                        return "Admin already assigned for this Client";
                        else if(val.endsWith("C") || !val.startsWith("C") || HomePageVM.instance.getClientsMap[val]==null )
                        return "Invalid Code";
                        else
                        return null;
                      },
                        inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter(RegExp('[C0-9]'), allow: true ),
                    ],
              
                        controller: _clientController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: b * 14, color: dc),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                          fillColor: Colors.white,
                          filled: true,
                          isDense: true,
                          hintText: 'Enter Client Code',
                          hintStyle: TextStyle(
                          fontSize: b * 14,
                            color: blc.withOpacity(0.25),
                          ),
                          enabledBorder: OutlineInputBorder(

                            borderSide: BorderSide(color: blc, width: 0.7),
                            borderRadius: BorderRadius.circular(b * 5),
                          ),
                          border: OutlineInputBorder(

                            borderSide: BorderSide(color: blc, width: 0.7),
                            borderRadius: BorderRadius.circular(b * 5),
                          ),
                        ),
                      ),
              sh(11),
              
              ],),
              sh(6),
              Text(
                  "Name",
                  style: TextStyle(
                    fontSize: b * 16,
                    color: dc,
                    fontWeight: FontWeight.w500,
                  ),
                  ),
              sh(6),
              TextFormField(
                        validator: (val){
                        if(val.isEmpty)
                        return "Name Cannot be empty";
                        else
                        return null;
                      },
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: b * 14, color: dc),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                          fillColor: Colors.white,
                          filled: true,
                          isDense: true,
                          hintText: 'Enter Name',
                          hintStyle: TextStyle(
                          fontSize: b * 14,
                            color: blc.withOpacity(0.25),
                          ),
                          enabledBorder: OutlineInputBorder(

                            borderSide: BorderSide(color: blc, width: 0.7),
                            borderRadius: BorderRadius.circular(b * 5),
                          ),
                          border: OutlineInputBorder(

                            borderSide: BorderSide(color: blc, width: 0.7),
                            borderRadius: BorderRadius.circular(b * 5),
                          ),
                        ),
                      ),
              sh(11),
              Text(
                  "Post",
                  style: TextStyle(
                    fontSize: b * 16,
                    color: dc,
                    fontWeight: FontWeight.w500,
                  ),
                  ),
              sh(6),   
              TextFormField(
                        validator: (val){
                        if(val.isEmpty)
                        return "Post Cannot be empty";
                        else
                        return null;
                      },
                        controller: _postnameController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: SizeConfig.b * 4.3),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                          fillColor: Colors.white,
                          filled: true,
                          isDense: true,
                          hintText: 'Enter Post',
                          hintStyle: TextStyle(
                          fontSize: b * 14,
                            color: blc.withOpacity(0.25),
                          ),
                          enabledBorder: OutlineInputBorder(

                            borderSide: BorderSide(color: blc, width: 0.7),
                            borderRadius: BorderRadius.circular(b * 5),
                          ),
                          border: OutlineInputBorder(

                            borderSide: BorderSide(color: blc, width: 0.7),
                            borderRadius: BorderRadius.circular(b * 5),
                          ),
                        ),
                      ),
              sh(11),
              Text(
                  "Mobile Number",
                  style: TextStyle(
                    fontSize: b * 16,
                    color: dc,
                    fontWeight: FontWeight.w500,
                  ),
                  ),
              sh(6), 
              TextFormField(
                      validator: (val){
                        int index= widget.list.indexWhere((element) => element.phoneNo.contains(val));
                        
                          if(val.isEmpty)
                          return "Phone Number Cannot be empty";
                          else if(val.length!=10)
                          return "Phone Number must be of 10 digits";
                          else if(index!=-1)
                          return "Phone No already registered"; 
                          else
                          return null;
                      },
                      controller: _phoneNumberController,
                      style: TextStyle(fontSize: SizeConfig.b * 4.3),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                          fillColor: Colors.white,
                          filled: true,
                        isDense: true,
                        hintText: 'Enter Phone Number',
                        hintStyle: TextStyle(
                          fontSize: b * 14,
                            color: blc.withOpacity(0.25),
                          ),
                          enabledBorder: OutlineInputBorder(

                            borderSide: BorderSide(color: blc, width: 0.7),
                            borderRadius: BorderRadius.circular(b * 5),
                          ),
                          border: OutlineInputBorder(

                            borderSide: BorderSide(color: blc, width: 0.7),
                            borderRadius: BorderRadius.circular(b * 5),
                          ),
                      ),
                    ),
              
              sh(15), 
              MaterialButton(
              color: Color(0xff00A3FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(b * 6),
              ),
              padding: EdgeInsets.zero,
              onPressed: () {
                if(admin && widget.adminDetail.key==null){
                  validateAddAdmin();
                }
                else if(admin && widget.adminDetail.key!=null){
                  validateReplaceAdmin();
                }
                else if(!admin){
                validateTeamMember();
                }
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: b * 16,
                    fontWeight: FontWeight.w500,
                  ),
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
