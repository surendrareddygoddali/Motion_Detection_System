import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gesture_collection_app/screens/library_home.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: TextField(
                controller: _emailController,
                decoration:  InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color:theme.colorScheme.secondary,
                      ),
                    ),
                    hintText: 'Email'),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration:  InputDecoration(
                  hintText: 'Password',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
              ),
              onPressed: () async {
                final message = await registration(
                  email: _emailController.text,
                  password: _passwordController.text,
                );
                if (message!.contains('Success')) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LibraryHome()));
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                  ),
                );
              },
              child: const Text('Create Account'),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                  MaterialPageRoute(
                    builder: (context) => LibraryHome(),
                  ),
                );
              },
              child:  Text(
                'Login',
                style: TextStyle(
                    color: theme.colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> registration({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }
}
