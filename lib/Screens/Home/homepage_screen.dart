import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Models/expense.dart';
import 'package:Canny/Screens/Dashboard/dashboard_screen.dart';
import 'package:Canny/Screens/Forum/forum_screen.dart';
import 'package:Canny/Screens/Insert Function/add_category.dart';
import 'package:Canny/Screens/Insert%20Function/add_spending.dart';
import 'package:Canny/Screens/Category/category_screen.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:Canny/Screens/Insert Function/add_targeted_expenditure.dart';
import 'package:Canny/Screens/Receipt/receipt_screen.dart';
import 'package:Canny/Services/Category/category_database.dart';
import 'package:Canny/Services/Receipt/receipt_database.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calculator/flutter_calculator.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/horizontal_scrollbar.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class HomePageScreen extends StatefulWidget {
  static final String id = 'homepage_screen';

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _selectedTab = 0;
  String uid = FirebaseAuth.instance.currentUser.uid;
  final _formKey = GlobalKey<FormState>();
  final ReceiptDatabaseService _authReceipt = ReceiptDatabaseService();
  final CollectionReference categoryCollection = Database().categoryDatabase();
  final CategoryDatabaseService _authCategory = CategoryDatabaseService();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController categoryNameController = TextEditingController();
  List<MultiSelectItem<Category>> _allCategories = [];
  List<Category> selectedCategory = [];
  String categoryId = '00';
  // Icon _icon;
  // bool isIncome = false;
  // String _title = 'CANNY';

  /*
  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void changeIsIncome() {
    setState(() => isIncome = !isIncome);
  }

  _pickIcon() async {
    IconData icon = await FlutterIconPicker.showIconPicker(context);
    _icon = Icon(icon,
      color: currentColor,
      size: 35,
    );
    setState((){});
    debugPrint('Picked Icon:  $icon');
  }

   */

  @override
  Widget build(BuildContext context) {

    List<Widget> _pageOptions = [
      DashboardScreen(),
      ReceiptScreen(),
      CategoryScreen(),
      ForumScreen(),
    ];

    List<BottomNavigationBarItem> _items = [
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.view_list),
        label: 'Receipt',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.category),
        label: 'Categories',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.forum),
        label: 'Forum',
      ),
    ];

    List<SpeedDialChild> _speedDailItems = [
      SpeedDialChild(
        child: Icon(
            Icons.attach_money_rounded,
          color: Colors.white,
        ),
        label: 'Add your Spendings',
        labelStyle: TextStyle(
            fontSize: 18,
          fontFamily: "Lato",
          color: kDarkBlue,
        ),
        backgroundColor: kDarkBlue,
        onTap: () {
          /*
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddSpendingScreen()));
          */
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              enableDrag: true,
              isScrollControlled: true,
              elevation: 5,
              context: context,
              builder: (BuildContext context) {
                return AddSpendingScreen();
              }
          );

        },
      ),
      SpeedDialChild(
        child: Icon(Icons.star,
          color: Colors.white,
        ),
        label: 'Enter your Target Expenditure',
        labelStyle: TextStyle(
          fontSize: 18,
          fontFamily: "Lato",
          color: kBlue,
        ),
        backgroundColor: kBlue,
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddTEScreen()));
          // print('Add Target Expenditure');

        },
      ),
      SpeedDialChild(
        child: Icon(Icons.category,
          color: Colors.white,
        ),
        label: 'Add a new Category',
        labelStyle: TextStyle(
          fontSize: 18,
          fontFamily: "Lato",
          color: kPalePurple,
        ),
        backgroundColor: kPalePurple,
        onTap: () {
          /*
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddCategoryScreen()));
          // print('Add Target Category');
           */
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              enableDrag: true,
              isScrollControlled: true,
              elevation: 5,
              context: context,
              builder: (BuildContext context) {
                return AddCategoryScreen();
              }
          );
        },
      ),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pageOptions[_selectedTab],
      bottomNavigationBar: Container(
        color: kDarkBlue,
        child: BottomNavigationBar(
          backgroundColor: kDarkBlue,
          elevation: 0,
          currentIndex: _selectedTab,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: kBlue,
          selectedItemColor: kLightBlue,
          selectedLabelStyle: TextStyle(fontFamily: 'Lato'),
          unselectedLabelStyle: TextStyle(fontFamily: 'Lato'),
          onTap: (int index) {
            setState(() {
              _selectedTab = index;
            });
          },
          items: _items,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SpeedDial(
        elevation: 7,
        marginBottom: 10,
        icon: Icons.menu,
        activeBackgroundColor: kLightBlueDark,
        activeIcon: Icons.clear,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        backgroundColor: kBlue,
        shape: CircleBorder(),
        buttonSize: 70.0,
        childMarginTop: 15.0,
        childMarginBottom: 15.0,
        children: _speedDailItems
      ),
    );
  }

  /*
  Widget addSpendingSheet(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(
                  children: <Widget> [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        Column(
                            children: <Widget> [
                              TextButton(
                                onPressed: () {
                                  itemNameController.clear();
                                  costController.clear();
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.clear),
                              ),
                              Text('Cancel'),
                            ]
                        ),
                        Spacer(),
                        Text('Add Your Expenses'),
                        Spacer(),
                        Column(
                            children: <Widget> [
                              TextButton(
                                onPressed: () async {
                                  final Expense expense = Expense(
                                    categoryId: selectedCategory[0].categoryId,
                                    cost: selectedCategory[0].isIncome
                                        ? double.parse(costController.text)
                                        : -(double.parse(costController.text)),
                                    itemName: itemNameController.text,
                                    uid: uid,
                                  );
                                  if (_formKey.currentState.validate()) {
                                    await _authReceipt.addExpense(expense);
                                    itemNameController.clear();
                                    costController.clear();
                                    Navigator.pop(context);
                                  }
                                },
                                child: Icon(Icons.check),
                              ),
                              Text('Add'),
                            ]
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Container(
                      alignment: Alignment.topCenter,
                      child: Form(
                        key: _formKey,
                        child: Column(
                            children: <Widget> [
                              _showTextFormFields(itemNameController,
                                "Enter the name of expense",
                                Icon(Icons.drive_file_rename_outline),
                                390.0,
                              ),
                              SizedBox(height: 15),
                              _showCalcFormFields(
                                "Enter the cost",
                                Icon(Icons.attach_money_rounded),
                              ),
                              getMultiSelectChipField(),
                            ]
                        ),
                      ),
                    ),
                  ]
              ),
            )
          ]
        )
      )
    );
  }

  Widget addCategorySheet(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: _authCategory.getCategories(),
      builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
        if (snapshot.hasData) {
          List<Category> allCategories = snapshot.data;
          allCategories.sort((a, b) => a.categoryId.compareTo(b.categoryId));
          categoryId = (int.parse(allCategories.last.categoryId) + 1).toString();
          return SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget> [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Column(
                              children: <Widget> [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget> [
                                    Column(
                                        children: <Widget> [
                                          TextButton(
                                            onPressed: () {
                                              _icon = null;
                                              pickerColor = Color(0xff443a49);
                                              currentColor = Color(0xff443a49);
                                              categoryNameController.clear();
                                              Navigator.pop(context);
                                            },
                                            child: Icon(Icons.clear),
                                          ),
                                          Text('Cancel'),
                                        ]
                                    ),
                                    Spacer(),
                                    Text('Add A New Category'),
                                    Spacer(),
                                    Column(
                                        children: <Widget> [
                                          TextButton(
                                            onPressed: () async {
                                              final Category category = Category(
                                                categoryName: categoryNameController.text,
                                                categoryColor: currentColor,
                                                categoryIcon: _icon,
                                                categoryId: categoryId,
                                                categoryAmount: 0,
                                                isIncome: isIncome,
                                              );
                                              if (_formKey.currentState.validate()) {
                                                await _authCategory.addNewCategory(category, category.categoryId);
                                                categoryNameController.clear();
                                                pickerColor = Color(0xff443a49);
                                                currentColor = Color(0xff443a49);
                                                _icon = null;
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Icon(Icons.check),
                                          ),
                                          Text('Add'),
                                        ]
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Container(
                                  alignment: Alignment.topCenter,
                                  child: Form(
                                      key: _formKey,
                                      child: Column(
                                          children: <Widget> [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget> [
                                                  SizedBox(width: 10.0),
                                                  CircleAvatar(
                                                    backgroundColor: pickerColor.withOpacity(0.1),
                                                    radius: 30,
                                                    child: AnimatedSwitcher(
                                                        duration: Duration(milliseconds: 300),
                                                        child: _icon != null
                                                            ? _icon
                                                            : Icon(FontAwesomeIcons.question, color: Colors.black)
                                                    ),
                                                  ),
                                                  _showTextFormFields(categoryNameController,
                                                      "Category Name",
                                                      Icon(Icons.drive_file_rename_outline),
                                                      250.0
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: <Widget> [
                                                TextButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text('Select a color'),
                                                          content: SingleChildScrollView(
                                                              child: Column(
                                                                  children: <Widget>[
                                                                    BlockPicker(
                                                                      pickerColor: currentColor,
                                                                      onColorChanged: changeColor,
                                                                    ),
                                                                    SizedBox(height: 10),
                                                                    TextButton(
                                                                        child: Text("Set as color",
                                                                          style: TextStyle(
                                                                            color: Colors.white,
                                                                          ),
                                                                        ),
                                                                        style: TextButton.styleFrom(
                                                                            backgroundColor: kDeepOrangeLight
                                                                        ),
                                                                        onPressed: () {
                                                                          setState(() => currentColor = pickerColor);
                                                                          Navigator.of(context).pop();
                                                                        }
                                                                    )
                                                                  ]
                                                              )
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text("Category Colour",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  style: TextButton.styleFrom(
                                                      backgroundColor: kDeepOrangeLight
                                                  ),
                                                ),
                                                SizedBox(height: 10.0),
                                                TextButton(
                                                  child: Text('Category Icon',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  style: TextButton.styleFrom(
                                                      backgroundColor: kDeepOrangeLight
                                                  ),
                                                  onPressed: _pickIcon,
                                                ),
                                                SizedBox(height: 10.0),
                                                // figure out why this wont work else change to dropdownmenu
                                                TextButton(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Icon(Icons.touch_app, size: 18),
                                                      SizedBox(width: 12),
                                                      Text(isIncome ? 'INCOME' : 'EXPENSE',
                                                          style: TextStyle(
                                                            color: isIncome
                                                                ? Colors.teal
                                                                : Colors.redAccent
                                                          ),
                                                      ),
                                                    ],
                                                  ),
                                                  style: TextButton.styleFrom(
                                                      backgroundColor: isIncome
                                                          ? Colors.teal.withOpacity(0.2)
                                                          : Colors.redAccent.withOpacity(0.2),
                                                  ),
                                                  onPressed: () {
                                                    changeIsIncome();
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                      content: Text(isIncome ? 'income' : 'expenses' + ' chosen'),
                                                      duration: Duration(seconds: 1),
                                                    ));
                                                  },
                                                )
                                              ]
                                            ),
                                            SizedBox(height: 10.0),
                                          ]
                                      ),
                                  )
                                ),
                              ]
                          ),
                        )
                      ]
                  )
              )
          );
        }
        return SizedBox();
      }
    );
  }

  Widget _showTextFormFields(TextEditingController text, String label, Icon icon, double size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: size,
        child: TextFormField(
          controller: text,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: icon,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          // The validator receives the text that the user has entered.
          validator: (value) {
            if (value.isEmpty) {
              return label;
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _showCalcFormFields(String label, Icon icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        //showCursor: false,
        readOnly: true,
        controller: this.costController,
        onTap: () => this._showCalculatorDialog(context),
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        // The validator receives the text that the user has entered.
        validator: (value) {
          if (value.isEmpty) {
            return label;
          }
          return null;
        },
      ),
    );
  }

  Widget getMultiSelectChipField() {
    return FutureBuilder<List<Category>>(
        future: _authCategory.getCategories(),
        builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
          if (snapshot.hasData) {
            List<Category> allCategories = snapshot.data;
            allCategories.sort((a, b) => a.categoryId.compareTo(b.categoryId));
            _allCategories = allCategories.map((category) =>
                MultiSelectItem<Category>(category, category.categoryName)).toList();
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: MultiSelectChipField(
                items: _allCategories,
                //scroll: false,
                scrollBar: HorizontalScrollBar(),
                searchable: true,
                title: Text("Select Your Categories",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16,
                  ),
                ),
                icon: Icon(Icons.check),
                headerColor: Colors.blue.withOpacity(0.5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue[700], width: 1.8),
                  borderRadius: BorderRadius.all(Radius.circular(7.5)),
                ),
                selectedChipColor: Colors.blue.withOpacity(0.5),
                selectedTextStyle: TextStyle(color: Colors.blue[800]),
                onTap: (categories) {
                  categories.length > 1
                      ? categories.removeAt(0)
                      : categories;
                  selectedCategory = categories;
                },
              ),
            );
          }
          return CircularProgressIndicator();
        }
    );
  }

  void _showCalculatorDialog(BuildContext context) async {
    final result = await showCalculator(context: this.context) ?? 0.00;

    this.costController.value = this.costController.value.copyWith(
      text: result.toStringAsFixed(2),
    );
  }
   */
}
