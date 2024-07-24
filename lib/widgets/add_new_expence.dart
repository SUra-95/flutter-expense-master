import 'package:expense_master/models/expence.dart';
import 'package:flutter/foundation.dart' as flutter_foundation;
import 'package:flutter/material.dart';

class AddNewExpence extends StatefulWidget {
  final void Function(ExpenceModel) onAddExpence;
  const AddNewExpence({super.key, required this.onAddExpence});

  @override
  State<AddNewExpence> createState() => _AddNewExpenceState();
}

class _AddNewExpenceState extends State<AddNewExpence> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  Category _selectedCategory = Category.leisure;

  // date variables
  final DateTime intialDate = DateTime.now();
  final DateTime firstDate = DateTime(
      DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
  final DateTime lastDate = DateTime(
      DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);
  DateTime _selectedDate = DateTime.now();

  Future<void> _openDateModel() async {
    try {
      // show the date model then store the user selected date
      final pickedDate = await showDatePicker(
          context: context, firstDate: firstDate, lastDate: lastDate);

      setState(() {
        _selectedDate = pickedDate!;
      });
    } catch (err) {
      print(err.toString());
    }
  }

  void _closeDialog() {
    Navigator.of(context).pop();
  }

  // handle form validation
  void handleFormSubmit() {
    // form validation
    // convert the amount to double
    final userAmount = double.parse(_amountController.text.trim());
    if (_titleController.text.trim().isEmpty || userAmount <= 0) {
      // if there is no title or the amount is negative then show a dialog box
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Enter Valid Data"),
            content: const Text(
                "Please enter valid data for the title and the amount here to continue. Title cannot be empty and the amount should not be less than or equal to 0"),
            actions: [
              TextButton(
                onPressed: _closeDialog,
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    } else {
      //create the new expence
      ExpenceModel newExpence = ExpenceModel(
          title: _titleController.text.trim(),
          amount: userAmount,
          date: _selectedDate,
          category: _selectedCategory);

      // save the data
      widget.onAddExpence(newExpence);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: "Add new expence title",
              label: Text("Title"),
            ),
            keyboardType: TextInputType.text,
            maxLength: 50,
          ),
          Row(
            children: [
              // amount
              Expanded(
                child: TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    hintText: "Enter the amount",
                    label: Text("Amount"),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),

              // date picker
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(formattedDate.format(_selectedDate)),
                    IconButton(
                      onPressed: _openDateModel,
                      icon: const Icon(Icons.date_range_outlined),
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(
                          category.name,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                  print(_selectedCategory);
                },
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // close the model button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.redAccent)),
                      child: const Text(
                        "Close",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    // save the data and close the model
                    ElevatedButton(
                      onPressed: handleFormSubmit,
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Color.fromARGB(255, 82, 216, 151)),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
