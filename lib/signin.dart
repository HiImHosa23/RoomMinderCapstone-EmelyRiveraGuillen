import 'package:flutter/material.dart';
import 'package:roommindercapstone/services/auth_service.dart';
import 'package:roommindercapstone/textfield.dart';

import 'models/user.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_add,
                  size: 100,
                ),
                Text(
                  "RoomMinder Sign Up",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TheTextField(
                  controller: nameController,
                  hintText: 'Name',
                  obscureText: false,
                ),
                SizedBox(height: 15),
                TheTextField(
                  controller: userController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                SizedBox(height: 15),
                TheTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                SizedBox(height: 15),
                TheTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // print("Name: ${nameController.text}");
                    // print("Username: ${userController.text}");
                    // print("Email: ${emailController.text}");
                    // print("Password: ${passwordController.text}");
                    User user = User(
                      name: nameController.text,
                      username: userController.text,
                      email: emailController.text,
                      password: passwordController.text,
                    );
                    String? error = await AuthService.register(user);

                    if(error != null){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error)),
                      );
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Registered!')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Sign Up'),
                ),
                // SizedBox(height: 20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text("Already a roommate? "),
                //     GestureDetector(
                //       onTap: (){
                //         Navigator.pop(context);
                //       },
                //       child: Text(
                //         'Log In',
                //         style: TextStyle(
                //           color: Colors.blue,
                //           decoration: TextDecoration.underline,
                //         ),
                //       ),
                //     )
                //   ],
                // ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
