import 'package:e_commerce/constants.dart';
import 'package:e_commerce/screens/home_page.dart';
import 'package:e_commerce/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        //if snapshot has error
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          //StreamBuilder can check login state live
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot){
              //if snapshot has error
              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${streamSnapshot.error}"),
                  ),
                );
              }

              //connection state active - user login check in if statement
              if(streamSnapshot.connectionState == ConnectionState.active){

                User _user = streamSnapshot.data;

                if(_user == null) {
                  return LoginPage();
                } else {
                  return HomePage();
                }
              }

              //checking the auth state -loading
              return Scaffold(
                body: Center(
                  child: Text("Checking Authentication....",
                    style: Constants.regularHeading,
                  ),
                ),
              );
            },
          );
        }
        //connecting to firebase
        return Scaffold(
          body: Center(
            child: Text("Initialization App....",
              style: Constants.regularHeading,
            ),
          ),
        );
      },
    );
  }
}
