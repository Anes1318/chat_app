import 'dart:io';

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MyForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String? userName,
    bool isLogin,
    File image,
  ) submitfn;
  final bool isLoading;
  const MyForm({required this.submitfn, required this.isLoading});

  @override
  State<MyForm> createState() => MyFormState();
}

class MyFormState extends State<MyForm> {
  final _form = GlobalKey<FormState>();

  bool _isLogin = true;
  Map<String, String> _authData = {
    'email': '',
    'username': '',
    'password': '',
  };
  File? userImageFile;

  void pickedImage(File image) {
    userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _form.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!_isLogin && userImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image'),
        ),
      );
      return;
    }

    if (isValid) {
      _form.currentState!.save();
      widget.submitfn(
        // _authData['email']!.trim(),
        _authData['email']!,
        _authData['password']!.trim(),
        _authData['username']!.trim(),
        _isLogin,
        userImageFile!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin)
                    UserImagePicker(
                      funkcija: pickedImage,
                    ),
                  TextFormField(
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email address'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                    },
                    onSaved: (value) {
                      _authData['email'] = value!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('userName'),
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(labelText: 'User Name'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                      },
                      onSaved: (value) {
                        _authData['username'] = value!;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'The passwrod must contain at least 7 characters';
                      }
                    },
                    onSaved: (value) {
                      _authData['password'] = value!;
                    },
                  ),
                  SizedBox(height: 12),
                  widget.isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => _trySubmit(),
                          child: Text(_isLogin ? 'Login' : 'Sign Up'),
                        ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin ? 'Create New Account' : 'I already have an account',
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
