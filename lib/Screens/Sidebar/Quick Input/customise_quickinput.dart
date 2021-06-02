import 'package:Canny/Database/all_database.dart';
import 'package:Canny/Models/category.dart';
import 'package:Canny/Screens/Home/homepage_screen.dart';
import 'package:Canny/Screens/Quick%20Input/quick_input.dart';
import 'package:Canny/Services/Category/category_database.dart';
import 'package:Canny/Services/Quick%20Input/quickinput_database.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';


class CustomiseQI extends StatefulWidget {
  @override
  _CustomiseQIState createState() => _CustomiseQIState();
}

class _CustomiseQIState extends State<CustomiseQI> {
  final String uid = FirebaseAuth.instance.currentUser.uid;
  final _formKey = GlobalKey<FormState>();
  final QuickInputDatabaseService _authQuickInput = QuickInputDatabaseService();
  final CategoryDatabaseService _authCategory = CategoryDatabaseService();
  final CollectionReference categoryCollection = Database().categoryDatabase();
  List<MultiSelectItem<Category>> _allCategories;

  final _testCategories = CategoryDatabaseService()
      .getAllCategories()
      .map((category) =>
          MultiSelectItem<Category>(category, category.categoryName))
      .toList();

  List<Category> selectedCategories;
  String firstSelectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColour,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'Select Your Top 3 Categories!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23.0,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    color: kDeepOrange,
                  ),
                ),
                SizedBox(height: 20.0),
                getMultiSelectDialogField(),
                // SizedBox(height: 20.0),
                // getMultiSelectChipField(),
                SizedBox(height: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () async {
                            // if selected less than 3, ask them select 3
                            if (selectedCategories == null || selectedCategories.length < 3) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text(
                                      "Please select 3 categories",
                                      style:
                                      TextStyle(fontFamily: 'Lato.Thin'),
                                    ),
                                    actions: <Widget> [
                                      TextButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                }
                              );
                            } else {
                              editQuickInput();
                              if (_formKey.currentState.validate()) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "Succesfully Edited Your Categories!",
                                        style: TextStyle(fontFamily: 'Lato'),
                                      ),
                                      content: Text(
                                        "Would you like to edit again?",
                                        style:
                                        TextStyle(fontFamily: 'Lato.Thin'),
                                      ),
                                      actions: <Widget>[
                                        Column(
                                          children: [
                                            TextButton(
                                              child: Text(
                                                  "Reedit Categories"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Back to homepage"),
                                              onPressed: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomePageScreen()));
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                  "Check Quick Input"),
                                              onPressed: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            QuickInput()));
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          },
                          child: Text('Submit'),
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(kDeepOrangeLight),
                          )
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePageScreen()));
                            },
                            child: Text('Return To Homepage'),
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Colors.grey),
                            ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // this way very ugly though
  Widget getFirstStreamBuilder() {
    return StreamBuilder(
        stream: categoryCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<DropdownMenuItem> categoryItems = [];
            for (DocumentSnapshot snap in snapshot.data.docs) {
              categoryItems.add(
                DropdownMenuItem(
                  child: Text(
                    snap['categoryName'],
                    style: TextStyle(color: Color(0xff11b719)),
                  ),
                  value: "${snap.id}",
                ),
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                SizedBox(width: 50.0),
                DropdownButton(
                  items: categoryItems,
                  onChanged: (category) {
                    setState(() {
                      firstSelectedCategory = category;
                    });
                  },
                  value: firstSelectedCategory,
                  isExpanded: false,
                  hint: Text(
                    "Choose Your Category",
                    style: TextStyle(color: Color(0xff11b719)),
                  ),
                ),
              ],
            );
          }
          return CircularProgressIndicator();
        });
  }

  void editFirstQuickInput() {
    categoryCollection.doc(firstSelectedCategory).get().then((value) {
      String categoryName = value['categoryName'];
      int categoryColorValue = value['categoryColorValue'];
      int categoryIconCodePoint = value['categoryIconCodePoint'];
      Category category = Category(
        categoryName: categoryName,
        categoryColor: Color(categoryColorValue),
        categoryIcon:
        Icon(IconData(categoryIconCodePoint, fontFamily: 'MaterialIcons')),
        categoryId: firstSelectedCategory,
      );
      _authQuickInput.updateQuickInput(category, firstSelectedCategory, 0);
    });
  }

  // TODO: see if this or DialogField is better
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
            padding: const EdgeInsets.all(15.0),
            child: MultiSelectChipField(
              items: _allCategories,
              scroll: false,
              searchable: true,
              title: Text("Select Your Categories",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              icon: Icon(Icons.check),
              headerColor: Colors.blue.withOpacity(0.5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue[700], width: 1.8),
              ),
              selectedChipColor: Colors.blue.withOpacity(0.5),
              selectedTextStyle: TextStyle(color: Colors.blue[800]),
              onTap: (categories) {
                categories.length > 3
                    ? categories.removeAt(0)
                    : categories;
                selectedCategories = categories;
              },
            ),
          );
        }
        return CircularProgressIndicator();
      }
    );
  }

  Widget getMultiSelectDialogField() {
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
            child: Container(
              height: 200.0,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
              child: MultiSelectDialogField(
                backgroundColor: Colors.white,
                searchable: true,
                items: _allCategories,
                title: Text("Categories"),
                selectedColor: Colors.blue,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                buttonIcon: Icon(
                  Icons.arrow_downward_outlined,
                  color: Colors.white,
                ),
                buttonText: Text(
                  "Select Your Categories",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onSelectionChanged: (categories) {
                  categories.length > 3
                      ? categories.removeAt(0)
                      : categories;
                },
                onConfirm: (categories) {
                  selectedCategories = categories;
                }
              ),
            ),
          );
        }
        return CircularProgressIndicator();
      }
    );
  }

  void editQuickInput() {
    for (int i = 0; i < 3; i++) {
      Category category = selectedCategories[i];
      String categoryId = category.categoryId;
      _authQuickInput.updateQuickInput(category, categoryId, i);
    }
  }

  // old codes to keep in case
  /*
  Widget getMultiSelectDialogField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 200.0,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: Colors.blue,
            width: 2,
          ),
        ),
        child: MultiSelectDialogField(
            chipDisplay: MultiSelectChipDisplay(
                icon: Icon(Icons.cancel),
                items: _allCategories,
                onTap: (value) {
                  setState(() {
                    selectedCategories.remove(value);
                  });
                }
            ),
            backgroundColor: Colors.white,
            searchable: true,
            items: _allCategories,
            title: Text("Categories"),
            selectedColor: Colors.blue,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8)),
              border: Border.all(
                color: Colors.blue,
                width: 2,
              ),
            ),
            buttonIcon: Icon(
              Icons.arrow_downward_outlined,
              color: Colors.white,
            ),
            buttonText: Text(
              "Select Your Categories",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            onSelectionChanged: (categories) {
              categories.length > 3
                  ?  categories.removeAt(0)
                  :  categories;
            },
            onConfirm: (categories) {
              selectedCategories = categories;
            }
        ),
      ),
    );
  }

  Widget getMultiSelectChipField() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: MultiSelectChipField(
        items: _allCategories,
        scroll: false,
        searchable: true,
        title: Text("Select Your Categories",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        icon: Icon(Icons.check),
        headerColor: Colors.blue.withOpacity(0.5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue[700], width: 1.8),
        ),
        selectedChipColor: Colors.blue.withOpacity(0.5),
        selectedTextStyle: TextStyle(color: Colors.blue[800]),
        onTap: (categories) {
          categories.length > 3
              ? categories.removeAt(0)
              : categories;
          selectedCategories = categories;
        },
      ),
    );
  }
  */
}