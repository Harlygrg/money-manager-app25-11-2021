

import 'package:flutter/material.dart';
import 'package:money_manager_app/widgetsUI/custom_widgets.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isSwitched =false;
  TimeOfDay? picked;
  String _selectedTime ='8: AM';
  Future<void> selectTime(BuildContext context) async {
    picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if(picked!=null){
      setState(() {
        _selectedTime =picked!.format(context);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff005c99),
        title: Text("Settings",),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 360,height: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0)),
                  child: ListTile(
                    leading: Text("Notification",
                      style:TextStyle(fontSize: 18) ,),
                    tileColor: Colors.orangeAccent,
                    title: isSwitched?TextButton(
                        onPressed: (){
                          selectTime(context);
                        },
                        child:
                        Text(_selectedTime,
                          style: TextStyle(color: Colors.black,fontSize: 18),)
                    ):null ,
//Text("${time!.hour}:${time!.minute}",),
                    trailing:Switch(
                      value: isSwitched,
                      onChanged: (bool value) {
//isSwitched=false;

                        setState(() {
                          isSwitched =value;
                        });

                      },
                      activeTrackColor: Colors.white,
                      activeColor: Colors.blue,
                    ),
                  ),
                ),
                divider(height: 10),
                listTileCard(
                    leading: "Privacy Policy",leadingFontSize: 18,
                    onTap: (){},
                    tileColor: Colors.orangeAccent
                ),
                divider(height: 10),
                listTileCard(
                    leading: "Terms and Conditions",leadingFontSize: 18,
                    onTap: (){},
                    tileColor: Colors.orangeAccent
                ),
                divider(height: 10),
                listTileCard(
                    leading: "About",leadingFontSize: 18,
                    onTap: (){
                      showAboutDialog(context: context,
                        applicationName: "Money Manager",

                      );
                    },
                    tileColor: Colors.orangeAccent
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
