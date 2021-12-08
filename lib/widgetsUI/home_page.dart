

import 'package:flutter/material.dart';
import 'package:money_manager_app/main.dart';
import 'package:money_manager_app/widgetsUI/custom_widgets.dart';
import 'package:money_manager_app/widgetsUI/transactions_page.dart';
import 'package:money_manager_app/widgetsUI/overview_page.dart';
import 'package:money_manager_app/widgetsUI/categories_page.dart';
import 'package:money_manager_app/actions/notification_api.dart';
import 'package:money_manager_app/widgetsUI/adding_expense_or_income.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int tabIndex;


  Widget tabbarTxt(
      {
        required String text,
      }
      )
  {
    return Text(text,
      style:TextStyle(
        fontSize: 15,
        fontFamily: "Outfit",
        fontWeight: FontWeight.w500,
      ),

    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this,initialIndex: 0);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6f0ff),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
        Color(0xff005c99),
        //Color(0xff0000ff),
        title: Text("Money Manager",style: TextStyle(
            shadows:const [
            Shadow(
              color: Colors.black,
              blurRadius: 4,
              offset: Offset(3,2.5),
            )],
          fontFamily: "Outfit"
        ),),
        actions: [
          appBarRightSideIconButton(
            onPressed: (){
              Navigator.pushNamed(context, 'pie_chart');
            },
            icon: Icon(Icons.pie_chart,
              color: Colors.white,
            ),
          ),
          appBarRightSideIconButton(
              onPressed: (){
                Navigator.pushNamed(context, 'SettingsPage');
              },
              icon:Icon( Icons.settings,)
          ),

        ],
        bottom: TabBar(
          controller: _tabController,
          tabs:<Widget> [
            Tab(
              child: tabbarTxt(text: "Overview"),
            ),
            Tab(
              child: tabbarTxt(text: "Transactions"),
            ),
            Tab(
              child: tabbarTxt(text: "Categories"),
            ),
          ],
          indicatorColor: Colors.white,
        ),

      ),
      body: TabBarView(


        controller: _tabController,
        children: [
          Overview(),
          Transactions(),
          Categories(),
        ],
      ),

      floatingActionButton:Material(
          type: MaterialType.transparency, //Makes it usable on any background color, thanks @IanSmith
          child: Ink(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white70, width: 4.0),
              color: appbarBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: InkWell(
              //This keeps the splash effect within the circle
              borderRadius: BorderRadius.circular(1000.0), //Something large to ensure a circle
              onTap: (){
                Navigator.pushNamed(context, "AddIncomeOrExpense");
              },
              child: Padding(
                padding:EdgeInsets.all(15.0),
                child: Icon(
                  Icons.add,
                  size: 30.0,
                  color: Colors.white,
                ),
              ),
            ),
          )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// floatingActoinButton(
//
// actions: (){
// Navigator.pushNamed(context, "AddIncomeOrExpense");
// }
// )
// listTileCard(
// leading: "Notifications",
// // onTap: (){
// //   Navigator.pop(context);
// //   selectTime(context);
// //   showDialog(context: context,
// //       builder: (context){
// //         return AlertDialog(
// //           //content:
// //           // Container(
// //           //   width: 150,
// //           //   child: Column(
// //           //     mainAxisSize: MainAxisSize.min,
// //           //     crossAxisAlignment:
// //           //     CrossAxisAlignment.start,
// //           //     children: [
// //           //       //Text("Time${time!.hour}:${time!.minute}",style: TextStyle(fontSize: 20),),
// //           //       // elevatedButton(
// //           //       //     buttonName: "SetNotification",
// //           //       //     onPressed: (){
// //           //       // })
// //           //     ],
// //           //   ),
// //           // ),
// //           actions: [
// //             Row(
// //               mainAxisAlignment:MainAxisAlignment.spaceEvenly ,
// //               children: [
// //                 Text("${time!.hour}:${time!.minute}  ${time!.period}",style: TextStyle(fontSize: 15),),
// //                 Switch(
// //                   value: isSwitched,
// //                   onChanged: (bool value) {
// //                     //isSwitched=false;
// //
// //                     setState(() {
// //                       isSwitched =value;
// //                       print(isSwitched);
// //
// //                     });
// //                     if(isSwitched==true){
// //                       selectTime(context);
// //                     }
// //
// //                   },
// //                   activeTrackColor: Colors.yellow,
// //                   activeColor: Colors.orangeAccent,
// //                 ),
// //               ],
// //             )
// //
// //           ],
// //         );
// //       }
// //   );
// //
// // },
// tileColor: Colors.orangeAccent
// ),