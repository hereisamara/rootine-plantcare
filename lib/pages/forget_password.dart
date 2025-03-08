import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rootine/pages/login.dart';

class ForgetPassword extends StatelessWidget {
  static final String routeId = 'forgetPasswordPage';
  const ForgetPassword({super.key});

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
                  ForgetPasswordForm(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ForgetPasswordForm extends StatefulWidget {
  const ForgetPasswordForm({
    super.key,
  });

  @override
  State<ForgetPasswordForm> createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset email sent')),
        );

        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No user found for the email.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send password reset email.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
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
              height: 24,
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff5B7A49),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: isLoading ? null : _resetPassword,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Reset Password',
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
                      text: 'Remembered your password? ',
                      style: TextStyle(color: Color(0xff74705F)),
                    ),
                    TextSpan(
                      text: 'Login',
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
