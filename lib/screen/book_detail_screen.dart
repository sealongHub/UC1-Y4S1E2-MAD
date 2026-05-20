import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad/controller/order_controller.dart';
import 'package:mad/model/orders.dart';
import 'package:mad/service/order_service.dart';

class BookDetailScreen extends StatefulWidget {
  const BookDetailScreen({super.key});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {

<<<<<<< HEAD
  Orders? _existingOrder;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkExistingOrder();
=======
  // Dependency Injection
  final orderController = Get.put(OrderController());

  Future<void> _orderProcess() async{
    final orderItem = Orders(
        bookId: 1,
        qty: 1,
        amount: 20000,
        phoneNumber: "01234567",
        discount : 0,
        totalAmount: 20000
    );
    orderController.orderList.add(orderItem);
    final snackBar = SnackBar(content: Text("Order success"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
>>>>>>> ed7e9763c32da740429a5621e54880dbcbbe51cd
  }

  // Check if this book is already in cart
  Future<void> _checkExistingOrder() async {
    setState(() => _isLoading = true);
    final orders = await OrderService.instance.readOrders();
    final found = orders.where((o) => o.bookId == 1).toList();
    setState(() {
      _existingOrder = found.isNotEmpty ? found.first : null;
      _isLoading = false;
    });
  }

  // Add to cart
  Future<void> _orderProcess() async {
    final orders = Orders(
      bookId: 1,
      qty: 1,
      amount: 20000,
      phoneNumber: "01234567",
      discount: 0,
      totalAmount: 20000,
    );
    await OrderService.instance.insertOrder(orders);
    await _checkExistingOrder();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Added to cart!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Show bottom sheet with order info + delete
  void _showOrderBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              SizedBox(height: 16),

              Text(
                "Order Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 16),

              // Book ID row
              _infoRow(Icons.book_outlined, "Book ID", "${_existingOrder?.bookId}"),
              SizedBox(height: 10),

              // Quantity row
              _infoRow(Icons.shopping_cart_outlined, "Quantity", "${_existingOrder?.qty}"),
              SizedBox(height: 10),

              // Unit price row
              _infoRow(Icons.attach_money, "Unit Price", "\$${_existingOrder?.amount?.toStringAsFixed(2)}"),
              SizedBox(height: 10),

              // Total amount row
              _infoRow(Icons.payment, "Total Amount", "\$${_existingOrder?.totalAmount?.toStringAsFixed(2)}", valueColor: Colors.green),
              SizedBox(height: 10),

              // Phone row
              _infoRow(Icons.phone_outlined, "Phone", "${_existingOrder?.phoneNumber}"),

              SizedBox(height: 24),

              Divider(),

              SizedBox(height: 12),

              // DELETE button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(context); // close bottom sheet
                    _showDeleteConfirmDialog();
                  },
                  icon: Icon(Icons.delete_outline, color: Colors.white),
                  label: Text(
                    "Remove from Cart",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              SizedBox(height: 8),

              // CLOSE button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text("Close", style: TextStyle(fontSize: 16)),
                ),
              ),

              SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // Confirm delete dialog
  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text("Remove Order"),
          ],
        ),
        content: Text("Are you sure you want to remove this order from cart?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              await OrderService.instance.deleteOrder(_existingOrder!.id!);
              Navigator.pop(context);
              await _checkExistingOrder();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Order removed from cart."),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text("Remove", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Info row helper
  Widget _infoRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        SizedBox(width: 10),
        Text("$label: ", style: TextStyle(color: Colors.grey.shade600)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    final bookImage = SizedBox(
      height: 300,
      child: Center(
        child: Image.asset(
          "assets/images/book2.png",
          height: 300,
          fit: BoxFit.cover,
        ),
      ),
    );

    List<Widget> star = List.generate(5, (i) {
      return Icon(Icons.star);
    }).toList();

    final rateStateRow = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: star,
    );

    final bookTitle = Text(
      "កម្រងគតិបណ្ឌិត",
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    );

    final author = Text("គឹម ពេជ្រពីរនន់");

    final description = Text(
      "រាប់ពាន់ឆ្នាំមកហើយដែលបុព្វបុរសជាច្រើនធ្លាប់បានរៀនសូត្រ ទទួលបទពិសោធផ្ទាល់ខ្លួន ឬត្រិះរិះពិចារណារកឃើញសច្ចភាព ដ៏មានតម្លៃផ្សេងៗនិងបានចងក្រងនូវអ្វីដែលខ្លួនបានរកឃើញទាំងនោះដើម្បីទុកជាប្រយោជន៍ដល់អនុជនជំនាន់ក្រោយ។",
    );

    // Button changes based on whether order exists
    final actionButton = Padding(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 16),
      child: SizedBox(
        height: 48,
        width: MediaQuery.of(context).size.width,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _existingOrder != null
                // Already in cart → show "View Order" button
                ? ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _showOrderBottomSheet,
                    icon: Icon(Icons.receipt_long, color: Colors.white),
                    label: Text(
                      "View Order",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                // Not in cart → show "Add to Cart" button
                : ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3051A0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _orderProcess,
                    icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
                    label: Text(
                      "Add to Cart",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'KantumruyPro',
                      ),
                    ),
                  ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text("Book Detail"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      bookImage,
                      rateStateRow,
                      bookTitle,
                      author,
                      SizedBox(height: 4),
                      Text("ពិពណ៌នា"),
                      SizedBox(height: 4),
                      description,
                    ],
                  ),
                ),
              ),
              actionButton,
            ],
          ),
        ),
      ),
    );
  }
}
