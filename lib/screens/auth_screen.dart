import 'dart:io';

import 'package:chat_app/widgets/myForm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  final BuildContext ctx;
  const AuthScreen(this.ctx);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;
  void submitAuthForm(String email, String password, String? userName, bool isLogin, File image) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        final reference = FirebaseStorage.instance.ref().child('userImages').child(authResult.user!.uid + '.jpg');
        reference.putFile(image).whenComplete(() async {
          await FirebaseFirestore.instance.collection('users').doc(authResult.user!.uid).set({
            'username': userName,
          });
        });
      }
    } on PlatformException catch (e) {
      String message = 'An error occured, please check you credentials';
      if (e.message != null) {
        message = e.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
      String message = 'An error occured, please check you credentials';

      if (e.toString().contains('The email address is already in use by another account')) {
        message = 'The email address is already in use by another account';
      }
      if (e.toString().contains('The password is invalid or the user does not have a password.')) {
        message = 'The password is invalid or the user does not have a password.';
      }
      if (e.toString().contains('There is no user record corresponding to this identifier')) {
        message = 'No user with that email';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: MyForm(
        isLoading: _isLoading,
        submitfn: submitAuthForm,
      ),
    );
  }
}
