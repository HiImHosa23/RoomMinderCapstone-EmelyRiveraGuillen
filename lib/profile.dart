import 'package:flutter/material.dart';
import 'package:roommindercapstone/models/user.dart';
import 'package:roommindercapstone/login.dart';
import 'package:roommindercapstone/main.dart';
// import 'package:roommindercapstone/services/user_service.dart';

class ProfilePg extends StatefulWidget {
  final User user;
  const ProfilePg({super.key, required this.user});

  @override
  State<ProfilePg> createState() => _ProfilePgState();
}

class _ProfilePgState extends State<ProfilePg> {
  bool darkMode = false;
  late String displayName;

  @override
  void initState(){
    super.initState();
    displayName = widget.user.name;
  }
  //
  // void _editName(){
  //   TextEditingController controller = TextEditingController(text: displayName);
  //
  //   showDialog(
  //     context: context,
  //     builder: (_) {
  //       return AlertDialog(
  //         title: Text("Edit Name"),
  //         content: TextField(
  //           controller: controller,
  //           decoration: InputDecoration(
  //             labelText: "New Name",
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: (){
  //               Navigator.pop(context);
  //             },
  //             child: Text("Cancel"),
  //           ),
  //           ElevatedButton(
  //             onPressed: () async {
  //               String newName = controller.text.trim();
  //               if(newName.isEmpty) return;
  //               bool success = await UserService.updateName(
  //                 widget.user.id!,
  //                 newName,
  //               );
  //             },
  //           )
  //         ],
  //       )
  //     }
  //   )
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: Color(0xFF4FAF9F),
              child: Icon(
                Icons.person,
                size: 45,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.user.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // IconButton(
                //   icon: Icon(Icons.edit),
                //   onPressed: _editName,
                // )
              ],
            ),
            Text(
             widget.user.email,
             style: TextStyle(
               color: Colors.grey[600],
             ),
            ),
            SizedBox(height: 30),
            Card(
              child: SwitchListTile(
                title: Text("Dark Mode"),
                secondary: Icon(Icons.dark_mode),
                value: darkMode,
                onChanged: (value){
                  setState(() {
                    darkMode = value;
                  });
                  MyApp.of(context)?.toggleDarkMode(value);
                },
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4FAF9F),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: (){
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoginPage(),
                    ),
                      (route) => false,
                  );
                },
                child: Text("Log Out"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
