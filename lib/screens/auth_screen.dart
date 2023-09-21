import 'package:chat_app/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String username,
    String password,
    image,
    bool isLogin,
  ) async {
    UserCredential authresult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authresult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authresult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(authresult.user!.uid + '.jpg');

      await ref.putFile(image).whenComplete(() => null);

      final url = await ref.getDownloadURL();

      FirebaseFirestore.instance
          .collection('user')
          .doc(authresult.user!.uid)
          .set({
        'username': username,
        'email': email,
        'image_url': url,
      });
    } on PlatformException catch (error) {
      var message = 'An erro occur, Please check the credential!';

      if (error.message != null) {
        message = error.message!;
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
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
