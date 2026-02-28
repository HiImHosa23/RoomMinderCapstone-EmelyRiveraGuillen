import 'package:flutter/material.dart';
import 'package:roommindercapstone/models/bill.dart';
import 'package:roommindercapstone/models/user.dart';

class BillPg extends StatefulWidget {
  final User user;
  const BillPg({
    super.key,
    required this.user,
});

  @override
  State<BillPg> createState() => _BillPgState();
}

class _BillPgState extends State<BillPg> {
  final titleController = TextEditingController();
  final totalController = TextEditingController();
  String splitType = "even";

  late List<String> roommates;
  late Map<String, bool> selected;
  late Map<String, TextEditingController> manualControl;

  @override
  void initState(){
    super.initState();
    roommates = [
      widget.user.name,
      "Jen",
      "Sam",
      "Claire"
    ];
    selected = {
      widget.user.name: false,
      "Jen": false,
      "Sam": false,
      "Claire": false,
    };
    manualControl = {
      widget.user.name: TextEditingController(),
      "Jen": TextEditingController(),
      "Sam": TextEditingController(),
      "Claire": TextEditingController(),
    };
  }

  void saveTheBill() {
    double total = double.tryParse(totalController.text) ?? 0;
    List<BillInfo> info = [];
    List<String> chosenmate =
        selected.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

    if(chosenmate.isEmpty) return;
    if(splitType == "even"){
      double each = total/chosenmate.length;
      for(var name in chosenmate){
        info.add(
          BillInfo(
            name: name,
            amount: each,
          ),
        );
      }
    }else{
      for(var name in chosenmate){
        double amt = double.tryParse(manualControl[name]!.text,) ?? 0;
        info.add(
          BillInfo(
            name: name,
            amount: amt,
          )
        );
      }
    }

    Bill bill = Bill(
      title: titleController.text,
      total: total,
      splitType: splitType,
      info: info,
    );
    print(bill.toJson());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Bill created"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> chosenmate =
        selected.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Bill Splitter"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Bill name",
              ),
            ),
            SizedBox(height: 10),
            Text("Roommates"),
            ...roommates.map((name){
              return CheckboxListTile(
                title: Text(name),
                value: selected[name],
                onChanged: (val){
                  setState(() {
                    selected[name] = val!;
                  });
                },
              );
            }),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    setState(() {
                      splitType = "even";
                    });
                  },
                  child: Text("Even"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: (){
                    setState(() {
                      splitType = "manual";
                    });
                  },
                  child: Text("Manual"),
                ),
              ],
            ),
            SizedBox(height: 10),
            if(splitType == "manual")
              Column(
                children: chosenmate.map((name) {
                  return TextField(
                    controller: manualControl[name],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: name,
                    ),
                  );
                }).toList(),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveTheBill,
              child: Text("Save Bill"),
            ),
          ],
        ),
      ),
    );
  }
}
