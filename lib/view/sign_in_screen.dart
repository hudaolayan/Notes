import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notes/utils/const_values.dart';
import 'package:notes/view/main_screen.dart';
import 'package:notes/view/sign_up_screen.dart';

import '../db/user_db_helper.dart';
import '../utils/shared_preferences_helper.dart';
import '../utils/validation_utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  UserDbHelper userDbHelper = UserDbHelper();

  bool obscureText = true;
  bool showErrorUsername = false;
  bool showErrorPassword = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Image.asset(
                "assets/images/logo.png",
                width: 100,
                height: 100,
                fit: BoxFit.fill,
              ),
              SizedBox(height: 40),
              TextField(
                controller: usernameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText:
                      showErrorUsername
                          ? AppLocalizations.of(context)!.error_username
                          : null,
                  prefixIcon: Icon(Icons.person),
                  label: Text(AppLocalizations.of(context)!.username),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: obscureText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText:
                      showErrorPassword
                          ? AppLocalizations.of(context)!.error_password
                          : null,
                  prefixIcon: Icon(Icons.password),
                  suffixIcon: IconButton(
                    onPressed: () {
                      obscureText = !obscureText;
                      setState(() {});
                    },
                    icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                  label: Text(AppLocalizations.of(context)!.password),
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (isValidSignInInfo()) {
                      signIn();
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.sign_in),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.dont_have_account),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.sign_up),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidSignInInfo() {
    showErrorUsername =
        !ValidationUtils.isValidUsername(username: usernameController.text);
    showErrorPassword = (passwordController.text.length < 8);

    setState(() {});

    if (showErrorUsername || showErrorPassword) {
      return false;
    } else {
      return true;
    }
  }

  signIn() async {
    try {
      bool doesUsernameExists = await userDbHelper.checkIfUserExists(
        username: usernameController.text,
      );
      if (!doesUsernameExists) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              icon: Icon(Icons.error, color: Colors.red),
              title: Text(AppLocalizations.of(context)!.error_title),
              content: Text(
                AppLocalizations.of(context)!.error_username_not_registered,
              ),
              actions: [
                MaterialButton(
                  child: Text("ok"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      } else {
        bool isCorrectData = await userDbHelper.signInUser(
          username: usernameController.text,
          password: passwordController.text,
        );
        if (isCorrectData) {
          await SharedPreferencesHelper().savePrefBool(
            key: ConstValues.isLoggedIn,
            value: true,
          );
          await SharedPreferencesHelper().savePrefString(
            key: ConstValues.username,
            value: usernameController.text,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                icon: Icon(Icons.error, color: Colors.red),
                title: Text(AppLocalizations.of(context)!.error_title),
                content: Text(
                  AppLocalizations.of(context)!.error_incorrect_password,
                ),
                actions: [
                  MaterialButton(
                    child: Text("ok"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      if (e is Exception) {
        print(e.toString());
      }
    }
  }
}
