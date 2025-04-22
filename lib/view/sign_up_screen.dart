import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notes/db/user_db_helper.dart';
import 'package:notes/utils/validation_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  UserDbHelper userDbHelper = UserDbHelper();

  bool obscureText = true;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool showErrorUsername = false;
  bool showErrorPassword = false;
  bool showErrorConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  errorText:
                      showErrorUsername
                          ? AppLocalizations.of(context)!.error_username
                          : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
              SizedBox(height: 20),
              TextField(
                controller: confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: obscureText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText:
                      showErrorConfirmPassword
                          ? AppLocalizations.of(
                            context,
                          )!.error_password_confirmation
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
                  label: Text(
                    AppLocalizations.of(context)!.passwordConfirmation,
                  ),
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (isValidSignupInfo()) {
                      signup();
                    }
                    setState(() {});
                  },
                  child: Text(AppLocalizations.of(context)!.sign_up),
                ),
              ),
              SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.already_registered),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.sign_in),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  signup() async {
    try {
      bool doesUsernameExists = await userDbHelper.checkIfUserExists(
        username: usernameController.text,
      );
      if (doesUsernameExists) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              icon: Icon(Icons.error, color: Colors.red),
              title: Text(AppLocalizations.of(context)!.error_title),
              content: Text(
                AppLocalizations.of(context)!.error_signup_user_exists,
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
        await userDbHelper.addUser(
          username: usernameController.text,
          password: passwordController.text,
        );

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              icon: Icon(Icons.info, color: Colors.green),
              title: Text(AppLocalizations.of(context)!.success_title),
              content: Text(AppLocalizations.of(context)!.account_created),
              actions: [
                MaterialButton(
                  child: Text(AppLocalizations.of(context)!.go_to_signin),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                MaterialButton(
                  child: Text(AppLocalizations.of(context)!.dismiss),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (e is Exception) {
        print(e.toString());
      }
    }
  }

  bool isValidSignupInfo() {
    showErrorUsername =
        !ValidationUtils.isValidUsername(username: usernameController.text);
    showErrorPassword = (passwordController.text.length < 8);
    showErrorConfirmPassword =
        (confirmPasswordController.text != passwordController.text);

    setState(() {});

    if (showErrorUsername || showErrorPassword || showErrorConfirmPassword) {
      return false;
    } else {
      return true;
    }
  }
}
