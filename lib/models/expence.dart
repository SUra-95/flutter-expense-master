import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'expence.g.dart';

// create a unique id using uuid package
final uuid = const Uuid().v4();

// date fomatter
final formattedDate = DateFormat.yMd();

// enum for category 
enum Category { food, travel, leisure, work }

// icons for category
final categoryIcons = {
  Category.food : Icons.lunch_dining,
  Category.leisure : Icons.leak_add,
  Category.travel : Icons.travel_explore,
  Category.work : Icons.work,
};

@HiveType(typeId: 1)
class ExpenceModel {

  // Constructor
  ExpenceModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  })
  : id = uuid;

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final Category category;

  // getter > get formattedDate 
  String get getFormattedDate {
    return formattedDate.format(date);
  }

}