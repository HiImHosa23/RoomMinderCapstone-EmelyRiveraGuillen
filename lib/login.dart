import 'package:flutter/material.dart';
import 'package:roommindercapstone/dashboard.dart';
import 'package:roommindercapstone/services/auth_service.dart';
import 'package:roommindercapstone/textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.house,
                size: 100,
              ),
              Text(
                "RoomMinder Login",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TheTextField(
                controller: userController,
                hintText: 'Username',
                obscureText: false,
              ),
              SizedBox(height: 15),
              TheTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () async {
              //     // final user = await AuthService.login(
              //     //   userController.text,
              //     //   passwordController.text,
              //     // );
              //     if(user == null){
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         const SnackBar(content: Text('Invalid Login')),
              //       );
              //     }else{
              //       Navigator.pushReplacement(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => DashboardPg(user: user)
              //         )
              //       );
              //     }
              //   },
              //   child: Text("Login")
              // ),
              ElevatedButton(
                onPressed: () async {
                  final user = await AuthService.login(
                    userController.text,
                    passwordController.text,
                  );
                  if(user == null){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid Login!!!')),
                    );
                  }else{
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardPg(user: user),
                      ),
                    );
                  }
                },
                child: Text("Log In"),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/register');
                },
                child: Text(
                  "Not a roommate? Sign Up",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text("Not a roommate? "),
              //     GestureDetector(
              //       onTap: (){
              //         Navigator.pushNamed(context, '/register');
              //       },
              //       child: Text(
              //         'Sign Up Here',
              //         style: TextStyle(
              //           color: Colors.blue,
              //           decoration: TextDecoration.underline,
              //         ),
              //       ),
              //     )
              //   ],
              // )
              
            ],
          ),
        ),
      ),
    );
  }
}
