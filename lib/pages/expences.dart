import 'package:expense_master/models/expence.dart';
import 'package:expense_master/server/database.dart';
import 'package:expense_master/widgets/add_new_expence.dart';
import 'package:expense_master/widgets/expence_list.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pie_chart/pie_chart.dart';

class Expences extends StatefulWidget {
  const Expences({super.key});

  @override
  State<Expences> createState() => _ExpencesState();
}

class _ExpencesState extends State<Expences> {
  final _myBox = Hive.box("expenceDatabase");
  Database db = Database();

  // expenceList

  // final List<ExpenceModel> _expenceList = [
  //   ExpenceModel(
  //       title: "Football",
  //       amount: 12.7,
  //       date: DateTime.now(),
  //       category: Category.leisure),
  //   ExpenceModel(
  //       title: "Burger",
  //       amount: 15.6,
  //       date: DateTime.now(),
  //       category: Category.food),
  //   ExpenceModel(
  //       title: "Photocopy",
  //       amount: 45.0,
  //       date: DateTime.now(),
  //       category: Category.work),
  // ];

  Map<String, double> dataMap = {
    "Food": 0,
    "Travel": 0,
    "Leisure": 0,
    "Work": 0,
  };

  // function to open the model overlay
  void _openAddExpencesOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddNewExpence(onAddExpence: onAddNewExpence);
      },
    );
  }

  // add new expence
  void onAddNewExpence(ExpenceModel expence) {
    setState(() {
      db.expenceList.add(expence);
      calCategoryValues();
    });
    db.updateData();
  }

  // remove a expence
  void onDeleteExpence(ExpenceModel expence) {
    // store the deleting expence
    ExpenceModel deletingExpence = expence;
    // get the index of the removing expence
    final int removingIndex = db.expenceList.indexOf(expence);
    setState(() {
      db.expenceList.remove(expence);
      calCategoryValues();
      db.updateData();
    });
    // show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Delete Expence Success"),
        action: SnackBarAction(
            label: "undo",
            onPressed: () {
              setState(() {
                db.expenceList.insert(removingIndex, deletingExpence);
                calCategoryValues();
              });
            }),
      ),
    );
  }

  // PIE CHART
  double foodVal = 0;
  double travelVal = 0;
  double leisureVal = 0;
  double workVal = 0;

  void calCategoryValues() {
    double foodValTotal = 0;
    double travelValTotal = 0;
    double leisureValTotal = 0;
    double workValTotal = 0;

    for (final expence in db.expenceList) {
      if (expence.category == Category.food) {
        foodValTotal += expence.amount;
      }
      if (expence.category == Category.leisure) {
        leisureValTotal += expence.amount;
      }
      if (expence.category == Category.work) {
        workValTotal += expence.amount;
      }
      if (expence.category == Category.travel) {
        travelValTotal += expence.amount;
      }
    }
    setState(() {
      foodVal = foodValTotal;
      travelVal = travelValTotal;
      leisureVal = leisureValTotal;
      workVal = workValTotal;
    });

    dataMap = {
      "Food": foodVal,
      "Travel": travelVal,
      "Leisure": leisureVal,
      "Work": workVal,
    };
  }

  @override
  void initState() {
    super.initState();

    // if this is the first time create the intial data
    if (_myBox.get("EXP_DATA") == null) {
      db.createInitialDatabase();
      calCategoryValues();
    }else{
      db.loadData();
      calCategoryValues();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 3, 197, 181),
        elevation: 0,
        // leading: const Icon(Icons.menu),
        title: const Text(
          "Expence Master",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Container(
            color: Colors.yellow,
            child: IconButton(
              onPressed: _openAddExpencesOverlay,
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          PieChart(dataMap: dataMap),
          ExpenceList(
              expenceList: db.expenceList, onDeleteExpence: onDeleteExpence)
        ],
      ),
    );
  }
}
