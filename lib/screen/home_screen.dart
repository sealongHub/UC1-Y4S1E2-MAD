import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad/controller/order_controller.dart';
import 'package:mad/data/shared_pref_manager.dart';
import 'package:mad/screen/book_detail_screen.dart';
import 'package:badges/badges.dart' as badges;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _fullName = "Guest";

  final orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final sharedPrefManager = SharedPrefManager();
    String fullName = await sharedPrefManager.getSharedPref("fullName");
    setState(() {
      _fullName = fullName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Text(
        "Hi, $_fullName",
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
    final subTitle = Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Text(
        "What do you want to read today?",
        style: TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );

    List<Widget> menuList = List.generate(50, (i) {
      return Card(
        elevation: 3,
        child: Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Text("ប្រលោមលោក"),
        ),
      );
    });
    final menuListRow = SizedBox(
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: menuList,
        ),
      ),
    );

    List<Widget> booksList = List.generate(30, (i) {
      return GestureDetector(
        child: Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Image.asset(
            "assets/images/book2.png",
            height: 250,
            fit: BoxFit.cover,
          ),
        ),
        onTap: (){
          final route = MaterialPageRoute(builder: (BuildContext context) => BookDetailScreen());
          Navigator.push(context, route);
        },
      );
    });
    final booksListRow = SizedBox(
      height: 260,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: booksList),
      ),
    );

    final cartItems = badges.Badge(
      badgeContent: Obx(() => Text("${orderController.orderList.length}")) ,
      child: Icon(Icons.shopping_cart),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [cartItems, Icon(Icons.more_vert)],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            title,
            subTitle,
            menuListRow,
            booksListRow,
            Text(
              "ការមកដល់ថ្មី",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            booksListRow,
          ],
        ),
      ),
    );
  }
}
