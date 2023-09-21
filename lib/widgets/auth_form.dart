import 'dart:io';

import 'package:chat_app/picker/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this._isLoading,
  );
  final bool _isLoading;
  final void Function(
    String email,
    String username,
    String password,
    File image,
    bool isLogin,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _logIn = true;
  String? _useEmail = '';
  String? _userName = '';
  String? _userPassword = '';
  var _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_logIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Pick an image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _useEmail!,
        _userName!,
        _userPassword!,
        _userImageFile,
        _logIn,
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
              key: _formKey,
              child: Column(
                children: [
                  if (!_logIn) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enetr the valid email';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(label: Text('Email')),
                    onSaved: (value) {
                      _useEmail = value;
                    },
                  ),
                  if (!_logIn)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 5) {
                          return 'Please enter at least 5 digits';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: Text('Username'),
                      ),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Please enter at least 7 digits';
                      }
                      return null;
                    },
                    decoration: InputDecoration(label: Text('Password')),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget._isLoading) CircularProgressIndicator(),
                  if (!widget._isLoading)
                    ElevatedButton(
                      child: Text(_logIn ? 'Login' : 'SignUp'),
                      onPressed: _trySubmit,
                    ),
                  if (!widget._isLoading)
                    TextButton(
                      child: Text(_logIn
                          ? 'Create new Account'
                          : 'I have already account'),
                      onPressed: () {
                        setState(() {
                          _logIn = !_logIn;
                        });
                      },
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
