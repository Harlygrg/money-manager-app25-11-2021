

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:money_manager_app/dialogue/policy_dialogue.dart';
import 'package:money_manager_app/widgetsUI/custom_widgets.dart';
import 'package:money_manager_app/actions/notification_api.dart';
import 'package:money_manager_app/widgetsUI/home_page.dart';
import '../main.dart';
import 'package:sizer/sizer.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isSwitched =false;
  TimeOfDay? picked;
  TimeOfDay notificationTime = TimeOfDay.now();
  int hr =0;
  int mn =0;
  String _selectedTime ='8:00 AM';
  Future<void> selectTime(BuildContext context) async {
    picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if(picked!=null){
      setState(() {
        _selectedTime =picked!.format(context);
        notificationTime=picked!;
        hr =notificationTime.hour;
        mn =notificationTime.minute;

      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationApi.init(initScheduled: true);
    listenNotifications();
    getSavedDataSettingsPage(context);
  }
  void listenNotifications(){
    NotificationApi.onNotifications.stream.listen(onClickedNotification);
  }
  void onClickedNotification(String ? payload){
    Navigator.of(context).push(MaterialPageRoute(builder:(context)=>const HomePage()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff005c99),
        title: Text("Settings",),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              divider(height: 30),
              Card(elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.0)),
                child: ListTile(
                  leading: Text("Notification",
                    style:TextStyle(fontSize: 13.sp,
                        fontFamily:  "Outfit",color: Colors.white,
                    fontWeight: FontWeight.w500) ,),
                  tileColor: appbarBackgroundColor,
                  title: TextButton(
                      onPressed: (){
                        selectTime(context);
                        setState(() {
                          isSwitched=false;
                        });
                      },
                    child:
                      Text(_selectedTime,
                        style: TextStyle(color: color2,fontSize:  13.sp,
                            fontFamily:  "Outfit",
                            fontWeight: FontWeight.w500),),
                  ) ,
                  trailing:Switch(
                    value: isSwitched,
                    onChanged: (bool value) {
                      saveSettingsPageDataToStorage(context);
                      //getSavedDataSettingsPage(context);
                      setState(() {
                        isSwitched =value;
                        if(isSwitched){
                          NotificationApi.showScheduledNotification(
                              scheduledTime: Time(hr,mn),
                              title: "Money Manager reminder",
                              body: "Don't forget to add your spending for today!",
                              payload: 'HomePage'
                          );
                        }
                        else{
                          NotificationApi().cancelNotification();
                        }
                      });

                    },
                    activeTrackColor: Colors.white,
                    activeColor: Colors.blue,
                  ),
                ),
              ),
              divider(height: 10),
              listTileCard(
                  leading: "Privacy Policy",leadingFontSize:  13.sp,
                  leadingTextColor: Colors.white,
                  onTap: (){
                    showDialog(context: context,
                        builder: (context){
                          return PolicyDialogue(mdFileName: 'privacy_policy.md');
                        });
                  },
                  tileColor: appbarBackgroundColor,
              ),
              divider(height: 10),
              listTileCard(
                  leading: "Terms and Conditions",leadingFontSize:  13.sp,
                  leadingTextColor: Colors.white,
                  onTap: (){
                    showDialog(context: context,
                        builder: (context){
                          return PolicyDialogue(mdFileName: 'terms_and_conditions.md');
                        });
                  },
                  tileColor: appbarBackgroundColor,
              ),
              divider(height: 10),
              listTileCard(
                  leading: "About",leadingFontSize:  13.sp,
                  leadingTextColor: Colors.white,
                  onTap: (){
                    showAboutDialog(context: context,
                      applicationName: "Money Manager",
                      applicationIcon: SizedBox(width: 50,height: 50,
                          child: Image.asset("ImageAssets/money_manager_icon_for_about.png"))

                    );
                  },
                  tileColor: appbarBackgroundColor,
              ),

            ],
          ),
        ),
      ),
    );
  }
  Future<void> saveSettingsPageDataToStorage(BuildContext context,)async{

    await sharedPreferences.setBool("notification", isSwitched);
    await sharedPreferences.setInt('hour',hr );
    await sharedPreferences.setInt('minute',mn );
  }

  Future<void>getSavedDataSettingsPage(BuildContext context,)async{
    final savedValue = sharedPreferences.getBool("notification");
    final savedHour = sharedPreferences.getInt("hour");
    final savedMinute = sharedPreferences.getInt("minute");
    if(savedHour!>12){
      if(savedMinute!<10){
        _selectedTime = "${savedHour-12}:0$savedMinute PM";
      }
      else{ _selectedTime = "${savedHour-12}:$savedMinute PM";}
    }
    else{
      if(savedMinute!<10){
        _selectedTime = "${savedHour}:0$savedMinute AM";
      }
      else{_selectedTime = "$savedHour:$savedMinute AM";}
    }
    if(savedHour!=hr && savedMinute!=mn){
      hr = savedHour;
      mn =savedMinute;
    }
    if(savedValue==false){
      isSwitched = true;
    }
    else{
      isSwitched =false;
    }
  }
}


