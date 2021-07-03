import 'package:Decon/Controller/Utils/sizeConfig.dart';
import 'package:Decon/Models/Consts/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';


class UpdateDialog extends StatefulWidget {
  final AppUpdateInfo updateInfo;
  UpdateDialog({this.updateInfo});
  @override
  _UpdateDialog createState() => _UpdateDialog();
}

class _UpdateDialog extends State<UpdateDialog> {
  
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _flexibleUpdateAvailable = false;
  bool _immediateUpdate = false;
  bool _showIndicator = false;

  immediateUpdate() async{
   await InAppUpdate.performImmediateUpdate()
                            .catchError((e) => AppConstant.showFailToast(context, "Error Occureed, Please update through play store." ) );
   Navigator.of(context).pop();
  }

  startFlexibleUpdate(){
  
    InAppUpdate.startFlexibleUpdate().then((_) {
                          setState(() {
                            _flexibleUpdateAvailable = true;
                            _showIndicator = false;
                          });
                            }).catchError((e) {
                          AppConstant.showFailToast(context, "Error Occureed, Please update through play store." );
                          Navigator.of(context).pop();
                        });
  }

  completeFlexibleUpdate(){
    InAppUpdate.completeFlexibleUpdate().then((_) {
                          AppConstant.showSuccessToast(context, "Updated Successfully" );
                          Navigator.of(context).pop();                          
                        }).catchError((e) {
                          AppConstant.showFailToast(context, "Error Occureed, Please update through play store." );
                          Navigator.of(context).pop();
                        });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 375;
    var h = SizeConfig.screenHeight / 812;
    
    return Dialog(
      backgroundColor: Colors.white,
      
        insetPadding: EdgeInsets.symmetric(
        horizontal:  b * 25,
        ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(b * 9),
      ),
    
      child: Container(
        padding: EdgeInsets.fromLTRB(b * 13, h * 16, b * 13, h * 16),
        decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(b * 9)
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              sh(4),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                            "New update avaiable!!",
                            style: TextStyle(
                              fontSize: b * 16,
                              color: dc,
                              fontWeight: FontWeight.w500,
                            ),
                            ),
                      ),
              sh(8),
              InkWell(
                onTap: (){
                  if(!_flexibleUpdateAvailable && widget.updateInfo?.flexibleUpdateAllowed){
                    startFlexibleUpdate();
                    _showIndicator = true;
                    setState(() {});
                  }else {
                    completeFlexibleUpdate();
                    setState(() {});
                  }
                },
                child: Container(
                      padding: EdgeInsets.symmetric(vertical: h * 10),
                      decoration: !_flexibleUpdateAvailable? BoxDecoration(
                        border: Border.all(color: blc),
                        borderRadius: BorderRadius.circular(b * 6)):
                        BoxDecoration(
                        color: blc,
                        borderRadius: BorderRadius.circular(b * 6)),
                      alignment: Alignment.center,
                      child: Text(
                        !_flexibleUpdateAvailable? 'Start Flexible Update'  : _showIndicator?'Please Wait...' :  'Complete Flexible Update',
                        style: !_flexibleUpdateAvailable? TextStyle(
                            color: blc,
                            fontSize: b * 16,
                            fontWeight: FontWeight.w500):
                            TextStyle(
                            color: Colors.white,
                            fontSize: b * 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
              ),
              sh(8),
              InkWell(
                onTap: (){
                  if(!_immediateUpdate && widget.updateInfo?.immediateUpdateAllowed){
                  _immediateUpdate = true;
                  immediateUpdate();
                  setState(() {});
                  }                  
                },
                child: Container(
                      padding: EdgeInsets.symmetric(vertical: h * 10),
                      decoration: !_immediateUpdate? BoxDecoration(
                        border: Border.all(color: blc),
                        borderRadius: BorderRadius.circular(b * 6)):
                        BoxDecoration(
                        color: blc,
                        borderRadius: BorderRadius.circular(b * 6)),
                      alignment: Alignment.center,
                      child: Text(
                         'Update Now'  ,
                        style: !_immediateUpdate? TextStyle(
                            color: blc,
                            fontSize: b * 16,
                            fontWeight: FontWeight.w500):
                            TextStyle(
                            color: Colors.white,
                            fontSize: b * 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
              ),            
              MaterialButton(
              color: Color(0xff00A3FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(b * 6),
              ),
              padding: EdgeInsets.zero,
              onPressed: () {
               Navigator.of(context).pop();
              },
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'Skip',
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
