import 'package:flutter/material.dart';
import 'package:roommindercapstone/models/user.dart';
import 'package:roommindercapstone/models/events.dart';
import 'package:roommindercapstone/services/ev_service.dart';


class ChorePg extends StatefulWidget {
  final User user;
  const ChorePg({super.key, required this.user});

  @override
  State<ChorePg> createState() => _ChorePgState();
}

class _ChorePgState extends State<ChorePg> {
  late List<String> roommates;

  @override
  void initState(){
    super.initState();
    roommates = [
      widget.user.name,
      "Jen",
      "Sam",
      "Claire"
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chore Assigner"),
      ),
      body: ListView.builder(
        itemCount: roommates.length,
        itemBuilder: (context, index){
          final roommate = roommates[index];
          final isUser = roommate == widget.user.name;
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                isUser ? "$roommate (You)" : roommate,
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: (){
                _openAssign(roommate);
              },
            ),
          );
        },
      ),
    );
  }
  //add logic here
  void _openAssign(String roommate){
    TextEditingController controller = TextEditingController();
    DateTime? selectedD;
    String selectedP = "Low";
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog){
          return AlertDialog(
            title: Text("Assign to $roommate"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "Enter Chore",
                  ),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      initialDate: DateTime.now(),
                    );
                    if(picked != null){
                      setStateDialog(() {
                        selectedD = picked;
                      });
                    }
                  },
                  child: Text(
                    selectedD == null
                        ? "Pick Date"
                        : selectedD!.toString().split(" ")[0],
                  ),
                ),
                SizedBox(height: 15),
                DropdownButton(
                  value: selectedP,
                  items: ["Low", "Medium", "High"]
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                    .toList(),
                  onChanged: (value){
                    setStateDialog((){
                      selectedP = value!;
                    });
                  },
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  if(controller.text.isNotEmpty && selectedD != null){
                    await EventService.addEvent(
                      controller.text,
                      selectedD!.toIso8601String(),
                      widget.user.id!,
                      assignedTo: roommate,
                      type: "chore",
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Chore assigned!"),
                      )
                    );
                  }
                },
                child: Text("Save"),
              )
            ],
          );
        },
      )
    );
  }
}
//Find a way to make the priority to actually work and find a way to show who it belongs to

