import 'package:expense_master/models/expence.dart';
import 'package:hive/hive.dart';

class Database {

  // create a database reference
  final _myBox = Hive.box("expenceDatabase");

  List<ExpenceModel> expenceList = [];

  // create the init expence list function
  void createInitialDatabase () {
    expenceList = [
        
    ExpenceModel(
        title: "Football",
        amount: 12.7,
        date: DateTime.now(),
        category: Category.leisure),
    ExpenceModel(
        title: "Burger",
        amount: 15.6,
        date: DateTime.now(),
        category: Category.food),
    ExpenceModel(
        title: "Photocopy",
        amount: 45.0,
        date: DateTime.now(),
        category: Category.work),
    ];
  }


  // load data
  void loadData () {
    final dynamic data = _myBox.get("EXP_DATA");

    // validate the data
    if (data != null && data is List<dynamic>) {
      expenceList = data.cast<ExpenceModel>().toList();
    }
  }

  // update the data

  Future <void> updateData () async {
    await _myBox.put("EXP_DATA", expenceList);
    print("data updated");
  }


}