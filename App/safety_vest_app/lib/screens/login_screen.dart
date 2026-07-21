import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool passwordVisible = false;
  bool loading = false;


  Future<void> login() async {

    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {

      showMessage("Please enter email and password");
      return;
    }


    setState(() {
      loading = true;
    });


    try {

      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );


      if (!mounted) return;


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );


    } on FirebaseAuthException catch (e) {


      String message = "Login failed";


      if (e.code == 'user-not-found') {
        message = "No user found";
      }

      else if (e.code == 'wrong-password') {
        message = "Incorrect password";
      }

      else if (e.code == 'invalid-email') {
        message = "Invalid email address";
      }


      showMessage(message);


    } finally {

      setState(() {
        loading = false;
      });

    }

  }



  void showMessage(String text){

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );

  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body: SafeArea(

        child: Center(

          child: SingleChildScrollView(

            padding: const EdgeInsets.all(24),

            child: Column(

              children: [


                // Logo

                Container(

                  width: 120,
                  height: 120,

                  decoration: BoxDecoration(

                    borderRadius:
                    BorderRadius.circular(30),

                    color:
                    Colors.white10,

                  ),

                  child: Image.asset(
                    'assets/icons/safety_vest_icon.png',
                  ),

                ),



                const SizedBox(height: 30),



                const Text(

                  "Smart Safety Vest",

                  style: TextStyle(

                    fontSize: 30,

                    fontWeight:
                    FontWeight.bold,

                    color:
                    Colors.white,

                  ),

                ),



                const SizedBox(height: 8),



                const Text(

                  "Worker Monitoring System",

                  style: TextStyle(

                    color:
                    Colors.white70,

                    fontSize:16,

                  ),

                ),



                const SizedBox(height:45),



                // Email

                TextField(

                  controller:
                  emailController,


                  keyboardType:
                  TextInputType.emailAddress,


                  decoration:
                  inputDecoration(

                    "Email",

                    Icons.email,

                  ),

                ),



                const SizedBox(height:20),



                // Password

                TextField(

                  controller:
                  passwordController,


                  obscureText:
                  !passwordVisible,


                  decoration:
                  inputDecoration(

                    "Password",

                    Icons.lock,

                    suffix: IconButton(

                      icon: Icon(

                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,

                      ),

                      onPressed:(){

                        setState(() {

                          passwordVisible =
                          !passwordVisible;

                        });

                      },

                    ),

                  ),

                ),



                const SizedBox(height:20),



                Align(

                  alignment:
                  Alignment.centerRight,


                  child: TextButton(

                    onPressed:(){},

                    child:
                    const Text(
                      "Forgot Password?",
                    ),

                  ),

                ),



                const SizedBox(height:20),



                SizedBox(

                  width:
                  double.infinity,


                  height:55,


                  child:
                  ElevatedButton(

                    onPressed:
                    loading
                        ? null
                        : login,


                    child:

                    loading

                        ?

                    const CircularProgressIndicator()

                        :

                    const Text(

                      "LOGIN",

                      style:
                      TextStyle(

                        fontSize:18,

                        fontWeight:
                        FontWeight.bold,

                      ),

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




  InputDecoration inputDecoration(

      String hint,

      IconData icon,

      {Widget? suffix}

      ){

    return InputDecoration(

      hintText:
      hint,


      prefixIcon:
      Icon(icon),


      suffixIcon:
      suffix,


      filled:true,


      fillColor:
      Colors.white10,


      border:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(18),

        borderSide:
        BorderSide.none,

      ),

    );

  }



  @override
  void dispose(){

    emailController.dispose();

    passwordController.dispose();

    super.dispose();

  }

}