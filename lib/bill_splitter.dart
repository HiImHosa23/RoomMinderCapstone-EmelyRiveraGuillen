import 'package:flutter/material.dart';
import 'package:roommindercapstone/models/bill.dart';
import 'package:roommindercapstone/models/user.dart';
import 'package:roommindercapstone/services/bill_service.dart';

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
  late Future<List> billsFuture;

  void _openBillDetails(Map bill){
    showDialog(
      context: context,
      builder: (_) {
        List roommatesList = bill["roommates"];
        return AlertDialog(
          title: Text(bill["title"]),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: roommatesList.map<Widget>((person) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(person["name"]),
                  Text("\$${person["amount"].toStringAsFixed(2)}"),
                ],
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            )
          ],
        );
      }
    );
  }

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
   _loadBills();
  }

  void _loadBills(){
    billsFuture = BillService.getTheBills();
  }

  void saveTheBill() async{
    double total = double.tryParse(totalController.text) ?? 0;
    List<BillInfo> roommatesList = [];
    List<String> chosen = selected.entries
      .where((e) => e.value)
      .map((e) => e.key)
      .toList();

    if(chosen.isEmpty){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Select at least one roommate")));
      return;
    }
    if(splitType == "even"){
      double each = total / chosen.length;
      for(var name in chosen){
        roommatesList.add(BillInfo(name: name, amount: each));
      }
    }else{
      for(var name in chosen){
        double amt = double.tryParse(manualControl[name]!.text) ?? 0;
        roommatesList.add(BillInfo(name: name, amount: amt));
      }
    }

    Bill bill = Bill(
      title: titleController.text,
      total: total,
      splitType: splitType,
      roommates: roommatesList,
    );

    await BillService.addTheBill(bill.toJson());
    ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text("Bill saved")));

    titleController.clear();
    totalController.clear();
    selected.updateAll((key, value) => false);
    manualControl.forEach((key, controller) => controller.clear());

    setState(() {
      _loadBills();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> chosen = selected.entries
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
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Bill name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: totalController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Total",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                   Wrap(
                     spacing: 10,
                     runSpacing: 10,
                     children: roommates.map((name) {
                       bool isSelected = selected[name]!;
                       return GestureDetector(
                         onTap: (){
                           setState(() {
                             selected[name] = !isSelected;
                           });
                         },
                         child: CircleAvatar(
                           radius: 30,
                           backgroundColor:
                           isSelected ? Color(0xFF4FAF9F) : Colors.grey[300],
                           child: Text(
                             name[0],
                             style: TextStyle(
                               color: isSelected ? Colors.white : Colors.black,
                               fontWeight: FontWeight.bold
                             ),
                           ),
                         ),
                       );
                     }).toList(),
                   ),
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
                    // SizedBox(height: 10),
                    if(splitType == "manual")
                      Column(
                        children: chosen.map((name) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextField(
                              controller: manualControl[name],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "$name's amount",
                                border: OutlineInputBorder()
                              ),
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
            ),
            SizedBox(height: 30),
            Text(
              "Bills",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            FutureBuilder(
              future: billsFuture,
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  );
                }
                final bills = snapshot.data!;
                if(bills.isEmpty){
                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("No bills yet"),
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(10),
                  itemCount: bills.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index){
                    final bill = bills[index];
                    return GestureDetector(
                      onTap: () => _openBillDetails(bill),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.teal[100],
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  bill["title"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Total: \$${bill["total"]}",
                                  style: TextStyle(fontSize: 14),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
