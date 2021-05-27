import 'package:Canny/Screens/Dashboard/dashboard_screen.dart';
import 'package:Canny/Screens/Forum/forum_screen.dart';
import 'package:Canny/Screens/Insert Function/add_category.dart';
import 'package:Canny/Screens/Insert Function/add_spending.dart';
import 'package:Canny/Screens/Insert Function/add_targeted_expenditure.dart';
import 'package:Canny/Screens/Leaderboard/leaderboard_screen.dart';
import 'package:Canny/Screens/Receipt/receipt_screen.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:flutter/material.dart';

class HomePageScreen extends StatefulWidget {
  static final String id = 'homepage_screen';

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _selectedTab = 0;
  // String _title = 'CANNY';

  List<Widget> _pageOptions = [
    DashboardScreen(),
    ReceiptScreen(),
    ForumScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_selectedTab],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(right: 92),
        child: BottomNavigationBar(
          elevation: 0.0,
          currentIndex: _selectedTab,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: kDeepOrangeLight,
          selectedItemColor: kDeepOrange,
          selectedLabelStyle: TextStyle(fontFamily: 'Lato'),
          unselectedLabelStyle: TextStyle(fontFamily: 'Lato'),
          onTap: (int index) {
            setState(() {
              _selectedTab = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              label: 'Receipt',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.forum),
              label: 'Forum',
            ),
            /*
            BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard),
              label: 'Leaderboard',
            ),

             */
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: kDeepOrangePrimary,
        onPressed: () {
          showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),

              ),
            ),
            isScrollControlled: true,
            elevation: 5,
            context: context,
            builder: (context) =>
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                      ListTile(
                        leading: Text('What input would you like to Add?',
                        style: TextStyle(
                          fontSize: 18,
                        )),
                        trailing: Icon(Icons.clear),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.monetization_on_outlined),
                        title: Text('Add your Spendings'),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => AddSpendingScreen()));
                          // print("Add Spending");
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.star),
                        title: Text('Enter your Target Expenditure'),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => AddTEScreen()));
                          // print('Add Target Expenditure');
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.category),
                        title: Text('Add a new Category'),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => AddCategoryScreen()));
                          // print('Add Target Category');
                        },
                      ),
                  ],
                ),
            );
          },
      ),
    );
  }
}
