import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rootine/api/api-services.dart';
import 'package:rootine/pages/login.dart';

class SignUp extends StatelessWidget {
  static final String routeId = 'signupPage';
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.white),
            ),
            Positioned(
              top: 86,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image(
                    width: 104,
                    height: 112,
                    image: AssetImage('assets/images/rootinelogo.png'),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Rootine',
                    style: TextStyle(
                      fontFamily: 'Grandstander',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 48,
                  ),
                  SignupForm(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  ApiService apiService = ApiService();

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        
        User? user = userCredential.user;
        
        if (user != null) {
          String? idToken = await user.getIdToken();

          // Call create user profile
          await apiService.createUserProfile(
            context: context,
            idToken: idToken!,
            name: nameController.text,
            photo: null, // Pass a File object if you have a photo to upload
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User profile created successfully')),
          );
        }

        Navigator.of(context).pushNamed(Login.routeId);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The password provided is too weak.')),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The account already exists for that email.')),
          );
        } else if (e.code == 'invalid-email') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The email address is not valid.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to sign up: ${e.message}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign up: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Password'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              obscureText: true,
              controller: confirmPasswordController,
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Confirm Password'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                return null;
              },
            ),
            SizedBox(
              height: 16,
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff5B7A49),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _signUp,
                child: Text(
                  'Signup',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Align(
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: Color(0xff74705F)),
                    ),
                    TextSpan(
                      text: 'login',
                      style: TextStyle(
                        color: Color(0xff41B200),
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () => Navigator.of(context).pushNamed(Login.routeId),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
