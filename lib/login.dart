import 'package:flutter/material.dart';
import 'package:roommindercapstone/dashboard.dart';
import 'package:roommindercapstone/services/auth_service.dart';
import 'package:roommindercapstone/textfield.dart';
import 'package:roommindercapstone/main_nav.dart';

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
      backgroundColor: Color(0xFFF3F8F7),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF4FAF9F).withOpacity(.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.house_rounded,
                    size: 70,
                    color: Color(0xFF4FAF9F),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "RoomMinder",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4FAF9F),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Welcome home!!! 🏡",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[700]
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15,
                        offset: Offset(0, 6),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
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
                      SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4FAF9F),
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                            ),
                          ),
                          onPressed: () async {
                            final user = await AuthService.login(
                              userController.text,
                              passwordController.text,
                            );
                            if(user == null){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Invalid Login"),
                                ),
                              );
                            }else{
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MainNavPg(user: user)
                                ),
                              );
                            }
                          },
                          child: Text(
                            "Log In",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    "Not a roommate? Sign up",
                    style: TextStyle(
                        color: Color(0xFF4FAF9F),
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
