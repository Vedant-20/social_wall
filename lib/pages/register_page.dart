import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/button.dart';
import '../components/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key,required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();


  void signUp()async{
    //show loading circle
    showDialog(context: context, builder: (context)=>const Center(
      child: CircularProgressIndicator(),
    ));

    //make sure password match
    if(passwordTextController.text != confirmPasswordTextController.text){
      //pop loading circle
      Navigator.pop(context);
      //show error to user
      displayMessage("Passwords don't match!");
      return;
    }

    //try creating the user
    try{
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailTextController.text, password: passwordTextController.text);

    //after creating the user, create a new document on firestore called Users
    FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set({
      'username': emailTextController.text.split('@')[0], //initial username
      'bio': 'Empty bio...' , //intial bio
      

    });


      //pop laoding circle
      if(context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch(e){

      //pop loading circle
      Navigator.pop(context);
      //show error to user
      displayMessage(e.code);
    }
  }


   //display a dialog message
  void displayMessage(String message){
    showDialog(context: context, builder: (context)=>AlertDialog(
      title: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  //logo
                  Icon(
                    Icons.lock,
                    size: 100,
                  ),
            
                  const SizedBox(
                    height: 50,
                  ),
                  //welcome back message
                  Text(
                    "Lets create an account for you",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
            
                  const SizedBox(
                    height: 25,
                  ),
            
                  //email textfield
            
                  MyTextField(
                      controller: emailTextController,
                      hintText: 'Email',
                      obscureText: false),
            
                  const SizedBox(
                    height: 10,
                  ),
            
                  //password textfield
            
                  MyTextField(
                      controller: passwordTextController,
                      hintText: 'Password',
                      obscureText: true),
            
                  const SizedBox(
                    height: 10,
                  ),

                    //confirm password textfield
                  MyTextField(
                      controller: confirmPasswordTextController,
                      hintText: 'Confirm Password',
                      obscureText: true),
            
                  const SizedBox(
                    height: 10,
                  ),
            
                  //sign up button
            
                  MyButton(onTap: signUp, text: 'Sign Up'),
            
                  const SizedBox(
                    height: 25,
                  ),
            
                  //go to register page
            
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account ?",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                          child: const Text(
                        "Login Now",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}