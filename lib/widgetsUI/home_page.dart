
import 'package:flutter/material.dart';
import 'package:money_manager_app/widgetsUI/custom_widgets.dart';
import 'package:money_manager_app/widgetsUI/transactions_page.dart';
import 'package:money_manager_app/widgetsUI/overview_page.dart';
import 'package:money_manager_app/widgetsUI/categories_page.dart';
import 'package:money_manager_app/widgetsUI/adding_expense_or_income.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isSwitched = true;
  TimeOfDay? time;
  TimeOfDay? picked;
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
        fontWeight: FontWeight.bold,
      ),

    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this,initialIndex: 0);
    time = TimeOfDay.now();

  }
  Future<Null> selectTime(BuildContext context) async {
    picked = await showTimePicker(context: context, initialTime: time!);
    if(picked!=null){
      setState(() {
        time = picked;
      });
    }
  }
  // tabIndexValue(){
  //   tabIndex = _tabController.index;
  //   return tabIndex;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff005c99),
        title: Text("Money Manager"),
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
                showDialog(context: context,
                    builder: (context){
                      return AlertDialog(
                          content: Container(
                            width: 100,height: 300,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                listTileCard(
                                    leading: "Notifications",
                                    onTap: (){
                                      Navigator.pop(context);
                                      //selectTime(context);
                                      showDialog(context: context,
                                          builder: (context){
                                            return AlertDialog(
                                              //content:
                                              // Container(
                                              //   width: 150,
                                              //   child: Column(
                                              //     mainAxisSize: MainAxisSize.min,
                                              //     crossAxisAlignment:
                                              //     CrossAxisAlignment.start,
                                              //     children: [
                                              //       //Text("Time${time!.hour}:${time!.minute}",style: TextStyle(fontSize: 20),),
                                              //       // elevatedButton(
                                              //       //     buttonName: "SetNotification",
                                              //       //     onPressed: (){
                                              //       // })
                                              //     ],
                                              //   ),
                                              // ),
                                              actions: [
                                                Row(
                                                  mainAxisAlignment:MainAxisAlignment.spaceEvenly ,
                                                  children: [
                                                    Text("${time!.hour}:${time!.minute}  ${time!.period}",style: TextStyle(fontSize: 15),),
                                                    Switch(
                                                      value: isSwitched,
                                                      onChanged: (value) {
                                                        //isSwitched=false;
                                                        setState(() {
                                                          isSwitched = value;
                                                          print(isSwitched);
                                                        });
                                                        selectTime(context);
                                                      },
                                                      activeTrackColor: Colors.yellow,
                                                      activeColor: Colors.orangeAccent,
                                                    ),
                                                  ],
                                                )

                                              ],
                                            );
                                          }
                                      );

                                    },
                                    tileColor: Colors.orangeAccent
                                ),
                                listTileCard(
                                    leading: "Privacy Policy",
                                    onTap: (){},
                                    tileColor: Colors.orangeAccent
                                ),
                                listTileCard(
                                    leading: "Terms and Conditions",
                                    onTap: (){},
                                    tileColor: Colors.orangeAccent
                                ),
                                listTileCard(
                                    leading: "About",
                                    onTap: (){
                                      showAboutDialog(context: context,
                                        applicationName: "Money Manager",

                                      );
                                    },
                                    tileColor: Colors.orangeAccent
                                )

                              ],
                            ),
                          )
                      );
                    }
                );
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

      floatingActionButton: floatingActoinButton(

          actions: (){
            Navigator.pushNamed(context, "AddIncomeOrExpense");
          }
      )
    );
  }
}
