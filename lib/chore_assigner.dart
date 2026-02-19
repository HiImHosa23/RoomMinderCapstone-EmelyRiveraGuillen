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

  }
}
