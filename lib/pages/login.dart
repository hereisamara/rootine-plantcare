import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rootine/api/api-services.dart';
import 'package:rootine/models/user_profile_data.dart';
import 'package:rootine/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:rootine/pages/forget_password.dart';
import 'package:rootine/pages/home.dart';
import 'package:rootine/pages/signup.dart';
import 'package:rootine/providers/user_profile_provider.dart';

class Login extends StatefulWidget {
  static final String routeId = 'loginPage';
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        await Provider.of<AuthenticationProvider>(context, listen: false).signIn(
          emailController.text,
          passwordController.text,
        );

        final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Home(
              userName: authProvider.userName!,
              idToken: authProvider.idToken!,
            ),
          ),
        );
      } on FirebaseAuthException catch (e) {
        String message = 'An error occurred during login. Please try again.';
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided.';
        } else if (e.code == 'invalid-email') {
          message = 'Invalid email provided.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
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
                  LoginForm(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        await Provider.of<AuthenticationProvider>(context, listen: false).signIn(
          emailController.text,
          passwordController.text,
        );

        final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
        // Fetch the user profile
        UserProfile userProfile = await ApiService().getUserProfile(context, authProvider.idToken!);
        // Set the user profile in UserProfileProvider
        Provider.of<UserProfileProvider>(context, listen: false).setUserProfile(userProfile);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Home(
              userName: authProvider.userName!,
              idToken: authProvider.idToken!,
            ),
          ),
        );
      } on FirebaseAuthException catch (e) {
        String message = 'An error occurred during login. Please try again. $e';
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided.';
        } else if (e.code == 'invalid-email') {
          message = 'Invalid email provided.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
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
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(ForgetPassword.routeId);
              },
              child: Text(
                'Forget Password?',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Color(0xff5B7A49)),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff5B7A49),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: isLoading ? null : _login,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Login',
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
                      text: 'Don\'t have an account yet? ',
                      style: TextStyle(color: Color(0xff74705F)),
                    ),
                    TextSpan(
                      text: 'Sign up',
                      style: TextStyle(
                        color: Color(0xff41B200),
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () => Navigator.of(context).pushNamed(SignUp.routeId),
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
