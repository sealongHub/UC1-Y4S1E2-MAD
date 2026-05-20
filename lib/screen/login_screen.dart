import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad/screen/forget_password_screen.dart';
import 'package:mad/screen/main_screen.dart';
import 'package:mad/screen/register_screen.dart';
import 'package:mad/widgets/app_logo.dart' as appLogo;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _obscureText = true;
  bool _isEmailValid = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _keyForm = GlobalKey<FormState>();

  void _onEmailChangeHandler(String email) {

    if (email.isNotEmpty && email.contains("@")) {

      setState(() {
        _isEmailValid = true;
      });

    } else {

      setState(() {
        _isEmailValid = false;
      });

    }
  }

  Future<void> _onLoginSubmitHandler() async {

    print("Email : ${emailController.text}");
    print("Password : ${passwordController.text}");

    if (_keyForm.currentState!.validate()) {

      String user = emailController.text.trim();
      String pass = passwordController.text.trim();

      final pref = await SharedPreferences.getInstance();

      // SAFE NULLABLE VARIABLES
      String? username = pref.getString("username");
      String? password = pref.getString("password");

      // No account found
      if (username == null || password == null) {

        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text("No account found. Please register first."),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        return;
      }

      // Login success
      if (user == username && pass == password) {

        print("Login success..");

        final snackBar = SnackBar(
          backgroundColor: Colors.green,
          content: Text("Login success"),
          duration: Duration(seconds: 2),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        await Future.delayed(Duration(seconds: 2));

        final route = MaterialPageRoute(
          builder: (BuildContext context) => MainScreen(),
        );

        Navigator.pushReplacement(context, route);

      } else {

        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text("Invalid Username or Password"),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final customLogo = SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: appLogo.logo,
    );

    final usernameTextField = Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: emailController,
        onChanged: _onEmailChangeHandler,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          suffixIcon: _isEmailValid
              ? Icon(Icons.check_circle, color: Colors.green)
              : Icon(Icons.check_circle),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          hintText: "Email",
        ),
        validator: (v) {

          if (v == null || v.isEmpty) {
            return "Email could not be blank.";
          }

          if (!v.contains("@")) {
            return "Invalid email.";
          }

          return null;
        },
      ),
    );

    final passwordTextField = Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        controller: passwordController,
        obscureText: _obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            onPressed: () {

              setState(() {
                _obscureText = !_obscureText;
              });

            },
            icon: _obscureText
                ? Icon(Icons.visibility_off)
                : Icon(Icons.visibility),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          hintText: "Password",
        ),
        validator: (v) {

          if (v == null || v.isEmpty) {
            return "Password could not be blank.";
          }

          return null;
        },
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 16,
      ),
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF3051A0),
          ),
          onPressed: _onLoginSubmitHandler,
          child: Text(
            "ចូលប្រើ",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );

    final forgetPassword = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {

            final route = MaterialPageRoute(
              builder: (BuildContext context) =>
                  ForgetPasswordScreen(),
            );

            Navigator.push(context, route);

          },
          child: Text("ភ្លេចលេខសង្ងាត់"),
        ),
      ],
    );

    final noAccount = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text("មិនមានគណនីទេ?"),

        TextButton(
          onPressed: () {

            final route = MaterialPageRoute(
              builder: (BuildContext context) =>
                  RegisterScreen(),
            );

            Navigator.push(context, route);

          },
          child: Text(
            "ចុះឈ្មោះ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );

    final orLineWidget = Row(
      children: [
        Expanded(child: Divider(thickness: 2)),
        Text("ឬក៏"),
        Expanded(child: Divider(thickness: 2)),
      ],
    );

    final socialWidget = Padding(
      padding: EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(
            Icons.facebook,
            color: Colors.blue,
            size: 40,
          ),

          SizedBox(width: 8),

          Icon(
            Icons.mail_outlined,
            color: Colors.red,
            size: 40,
          ),
        ],
      ),
    );

    final loginForm = Form(
      key: _keyForm,
      child: Column(
        children: [
          usernameTextField,
          passwordTextField,
          forgetPassword,
        ],
      ),
    );

    final skipButton = TextButton(
      onPressed: () {
<<<<<<< HEAD

        final route = MaterialPageRoute(
          builder: (BuildContext context) => MainScreen(),
        );

        Navigator.pushReplacement(context, route);

=======
        // final route = MaterialPageRoute(
        //   builder: (BuildContext context) => MainScreen(),
        // );
        // Navigator.pushReplacement(context, route);

        Get.off(MainScreen());
>>>>>>> ed7e9763c32da740429a5621e54880dbcbbe51cd
      },
      child: Text(
        "រំលង",
        style: TextStyle(color: Colors.blue),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            customLogo,

            loginForm,

            loginButton,

            noAccount,

            orLineWidget,

            socialWidget,

            SizedBox(height: 40),

            skipButton,
          ],
        ),
      ),
    );
  }
}