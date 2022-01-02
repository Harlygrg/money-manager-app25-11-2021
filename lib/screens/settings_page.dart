import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:money_manager_app/controls/home_chart_settings_login_controller.dart';
import 'package:money_manager_app/dialogue/policy_dialogue.dart';
import 'package:money_manager_app/screens/custom_widgets.dart';
import 'package:money_manager_app/model/notification_api.dart';

import 'package:sizer/sizer.dart';

class Setting extends StatelessWidget {
  Setting({Key? key}) : super(key: key);
  final settinController = Get.find<HomeChartSettingsLoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff005c99),
        title: Text(
          "Settings",
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              divider(height: 30),
              GetBuilder<HomeChartSettingsLoginController>(
                  builder: (controller) {
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  child: ListTile(
                    leading: Text(
                      "Notification",
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: "Outfit",
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    tileColor: appbarBackgroundColor,
                    title: TextButton(
                      onPressed: () {
                        settinController.selectTime(context);
                        settinController.isSwitched = false;
                        settinController.updateSettings();
                      },
                      child: Text(
                        settinController.selectedTime,
                        style: TextStyle(
                            color: color2,
                            fontSize: 13.sp,
                            fontFamily: "Outfit",
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    trailing: Switch(
                      value: settinController.isSwitched,
                      onChanged: (bool value) {
                        settinController.updateSettings();
                        settinController.saveSettingsPageDataToStorage(context);
                        //getSavedDataSettingsPage(context);
                        settinController.isSwitched = value;
                        if (settinController.isSwitched) {
                          NotificationApi.showScheduledNotification(
                              scheduledTime: Time(
                                  settinController.hr, settinController.mn),
                              title: "Money Manager reminder",
                              body:
                                  "Don't forget to add your spending for today!",
                              payload: 'HomePage');
                        } else {
                          NotificationApi().cancelNotification();
                        }
                        settinController.updateSettings();
                      },
                      activeTrackColor: Colors.white,
                      activeColor: Colors.blue,
                    ),
                  ),
                );
              }),
              divider(height: 10),
              listTileCard(
                leading: "Privacy Policy",
                leadingFontSize: 13.sp,
                leadingTextColor: Colors.white,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return PolicyDialogue(mdFileName: 'privacy_policy.md');
                      });
                },
                tileColor: appbarBackgroundColor,
              ),
              divider(height: 10),
              listTileCard(
                leading: "Terms and Conditions",
                leadingFontSize: 13.sp,
                leadingTextColor: Colors.white,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return PolicyDialogue(
                            mdFileName: 'terms_and_conditions.md');
                      });
                },
                tileColor: appbarBackgroundColor,
              ),
              divider(height: 10),
              listTileCard(
                leading: "About",
                leadingFontSize: 13.sp,
                leadingTextColor: Colors.white,
                onTap: () {
                  showAboutDialog(
                      context: context,
                      applicationName: "Money Manager",
                      applicationIcon: SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.asset(
                              "ImageAssets/money_manager_icon_for_about.png")));
                },
                tileColor: appbarBackgroundColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
