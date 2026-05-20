import 'package:flutter/material.dart';
import 'package:mad/screen/login_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  Future<void> _onLogoutSubmitHandler() async {

    print("Logout success");

    // Redirect to Login Screen
    final route = MaterialPageRoute(
      builder: (BuildContext context) => LoginScreen(),
    );

    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {

    final logoutButton = Padding(
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 16,
      ),
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
<<<<<<< HEAD
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF3051A0),
          ),
          onPressed: _onLogoutSubmitHandler,
          child: Text(
            "ចាកចេញ",
            style: TextStyle(color: Colors.white),
=======
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFD45555)),
          onPressed: _onLogoutSubmitHandler,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("ចាកចេញ", style: TextStyle(color: Colors.white)),
              SizedBox(width: 4,),
              Icon(Icons.logout_outlined, color: Colors.white,)
            ],
>>>>>>> ed7e9763c32da740429a5621e54880dbcbbe51cd
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 3,
      ),
<<<<<<< HEAD
      body: SafeArea(
        child: Column(
          children: [

            Expanded(
              child: Center(
                child: Text("Account"),
              ),
            ),

            logoutButton,
          ],
        ),
      ),
=======
      body: SafeArea(child: Column(
        children: [
          Expanded(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text("Chhai Chivon"),
                    subtitle: Text("Full Name"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.mail),
                    title: Text("mad@gmail.com"),
                    subtitle: Text("Email"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.shopping_cart),
                    title: Text("Order"),
                    subtitle: Text("Cart"),
                  ),
                  Divider()
                ],
              )
          ),
          logoutButton
        ],
      )),
>>>>>>> ed7e9763c32da740429a5621e54880dbcbbe51cd
    );
  }
}