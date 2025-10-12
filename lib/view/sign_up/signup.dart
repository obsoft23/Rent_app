// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, avoid_print, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:rentapp/components/socials_button.dart';
import 'package:rentapp/theme/constants.dart';
import 'package:rentapp/theme/theme.dart';
import 'package:rentapp/view/login/login.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isTextFieldFilled = false;
  bool isEmail = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkTextField);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  void _checkTextField() {
    if (_passwordController.text.length >= 6) {
      setState(() {
        _isTextFieldFilled = true;
      });
    } else {
      setState(() {
        _isTextFieldFilled = false;
      });
      print("stays false");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: kDefaultIconDarkColor, //change your color here
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Create your account",
              style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            //   Text("Step 1/3", style: subTitle4),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_sharp),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FadeTransition(
              opacity: _animation,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(11.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(labelText: 'Email'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              } else {
                                isEmail = RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value);
                                if (!isEmail) {
                                  return 'Please provide a valid email address';
                                }
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _emailController.text = value!;
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              } else if (value.length < 6 ||
                                  _confirmPasswordController.text.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _passwordController.text = value!;
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            // controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              } else if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              } else if (value.length < 6 ||
                                  _passwordController.text.length < 6) {
                                return 'Password must be at least 6 characters';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _confirmPasswordController.text = value!;
                            },
                          ),
                          // SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ),
                  //
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          // You can implement your login logic here
                          // print('Email: $_email, Password: $_password');
                          print("about to register user");
                          /*  await authController.registerUser(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            context,
                          );*/
                        }
                        //Get.to(() => LocationPermissionRequestPage());
                      },
                      child: Ink(
                        width: double.infinity,
                        height: 56.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(10.0),
                          color: _isTextFieldFilled ? igBlue : igBg,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Create Account",
                              style: TextStyle(
                                color: kDefaultIconDarkColor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SocialButton(
                        text: "Sign up",
                        onTap: () {
                          //
                        },
                        icon: Icon(Icons.facebook),
                      ),
                      SocialButton(
                        text: "Sign up",
                        onTap: () {
                          //
                          // authController.signInWithGoogle(context);
                        },
                        icon: SvgPicture.asset("assets/icons/google.svg"),
                      ),
                    ],
                  ),
                  SizedBox(height: 23),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => LoginPage());
                          },
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
