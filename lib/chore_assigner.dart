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
  String _getProfileImage(String name){
    switch (name){
      case "Jen":
        return "assets/jen.jpg";
      case "Sam":
        return "assets/sam.jpg";
      case "Claire":
        return "assets/claire.jpg";
      default:
        return "assets/user.jpg";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chore Assigner"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: roommates.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (context, index){
              final roommate = roommates[index];
              final isUser = roommate == widget.user.name;

              return GestureDetector(
                onTap: (){
                  _openAssign(roommate);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage(
                        _getProfileImage(roommate),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      isUser ? "$roommate (You)" : roommate,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  //add logic here
  void _openAssign(String roommate){
    TextEditingController controller = TextEditingController();
    DateTime? selectedD;
    TimeOfDay? selectedT;
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
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if(picked != null){
                      setStateDialog((){
                        selectedT = picked;
                      });
                    }
                  },
                  child: Text(
                    selectedT == null
                        ? "Pick Time"
                        : selectedT!.format(context),
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
                    DateTime finalDate = DateTime(
                      selectedD!.year,
                      selectedD!.month,
                      selectedD!.day,
                      selectedT?.hour ?? 0,
                      selectedT?.minute ?? 0,
                    );
                    await EventService.addEvent(
                      controller.text,
                      finalDate.toIso8601String(),
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

