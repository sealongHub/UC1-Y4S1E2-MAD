import 'package:flutter/material.dart';
import 'package:mad/model/orders.dart';
import 'package:mad/service/order_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Orders> orderList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => isLoading = true);
    final data = await OrderService.instance.readOrders();
    setState(() {
      orderList = data;
      isLoading = false;
    });
  }

  // ─── GRAND TOTAL ─────────────────────────────────────────────
  double get grandTotal =>
      orderList.fold(0, (sum, o) => sum + (o.totalAmount ?? 0));

  // ─── INCREASE QTY ────────────────────────────────────────────
  Future<void> _increaseQty(Orders order) async {
    final newQty = (order.qty ?? 1) + 1;
    final unitPrice = (order.amount ?? 0);
    final newTotal = unitPrice * newQty;

    final updated = Orders(
      id: order.id,
      bookId: order.bookId,
      qty: newQty,
      amount: unitPrice,
      phoneNumber: order.phoneNumber,
      discount: order.discount,
      totalAmount: newTotal,
    );

    await OrderService.instance.updateOrder(updated);
    await _loadOrders();
  }

  // ─── DECREASE QTY ────────────────────────────────────────────
  Future<void> _decreaseQty(Orders order) async {
    if ((order.qty ?? 1) <= 1) {
      _showDeleteDialog(order.id!);
      return;
    }

    final newQty = (order.qty ?? 1) - 1;
    final unitPrice = (order.amount ?? 0);
    final newTotal = unitPrice * newQty;

    final updated = Orders(
      id: order.id,
      bookId: order.bookId,
      qty: newQty,
      amount: unitPrice,
      phoneNumber: order.phoneNumber,
      discount: order.discount,
      totalAmount: newTotal,
    );

    await OrderService.instance.updateOrder(updated);
    await _loadOrders();
  }

  // ─── DELETE DIALOG ───────────────────────────────────────────
  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text("Remove Item"),
            ],
          ),
          content: Text("Are you sure you want to remove this item from cart?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                await OrderService.instance.deleteOrder(id);
                Navigator.pop(context);
                await _loadOrders();
              },
              child: Text("Remove", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // ─── CLEAR ALL DIALOG ────────────────────────────────────────
  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Clear Cart"),
        content: Text("Remove all items from cart?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              for (var o in orderList) {
                await OrderService.instance.deleteOrder(o.id!);
              }
              Navigator.pop(context);
              await _loadOrders();
            },
            child: Text("Clear All", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── CHECKOUT DIALOG ─────────────────────────────────────────
  void _showCheckoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text("Confirm Order"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("You are about to place an order for:"),
              SizedBox(height: 12),
              ...orderList.map(
                (o) => Padding(
                  padding: EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Book ID: ${o.bookId}  x${o.qty}"),
                      Text(
                        "\$${o.totalAmount?.toStringAsFixed(2)}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Grand Total", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    "\$${grandTotal.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Order placed successfully!"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text("Place Order", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // ─── BUILD ───────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 3,
        title: Text("My Cart"),
        centerTitle: true,
        actions: [
          if (orderList.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_sweep),
              tooltip: "Clear All",
              onPressed: _showClearAllDialog,
            ),
        ],
      ),

      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : orderList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        "Your cart is empty",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Add some books to get started!",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [

                    // ── ORDER LIST ──────────────────────────────
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadOrders,
                        child: ListView.builder(
                          padding: EdgeInsets.all(12),
                          itemCount: orderList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final orderItem = orderList[index];

                            return Card(
                              elevation: 4,
                              margin: EdgeInsets.only(bottom: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  children: [

                                    // IMAGE
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        "https://picsum.photos/seed/${orderItem.bookId}/200/300",
                                        width: 80,
                                        height: 110,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 80,
                                          height: 110,
                                          color: Colors.grey.shade200,
                                          child: Icon(Icons.book, color: Colors.grey),
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 14),

                                    // CONTENT
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          // BOOK ID + DELETE ICON
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Book ID: ${orderItem.bookId}",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => _showDeleteDialog(orderItem.id!),
                                                child: Icon(Icons.delete_outline, color: Colors.red, size: 22),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 4),

                                          // UNIT PRICE
                                          Text(
                                            "Unit: \$${orderItem.amount?.toStringAsFixed(2)}",
                                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                          ),

                                          SizedBox(height: 6),

                                          // TOTAL AMOUNT
                                          Text(
                                            "\$${orderItem.totalAmount?.toStringAsFixed(2)}",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          SizedBox(height: 10),

                                          // QTY CONTROLS ── [ - ]  2  [ + ]
                                          Row(
                                            children: [

                                              // DECREASE BUTTON
                                              GestureDetector(
                                                onTap: () => _decreaseQty(orderItem),
                                                child: Container(
                                                  width: 34,
                                                  height: 34,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red.shade50,
                                                    border: Border.all(color: Colors.red),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Icon(Icons.remove, color: Colors.red, size: 18),
                                                ),
                                              ),

                                              // QTY DISPLAY
                                              Container(
                                                width: 44,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "${orderItem.qty ?? 1}",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),

                                              // INCREASE BUTTON
                                              GestureDetector(
                                                onTap: () => _increaseQty(orderItem),
                                                child: Container(
                                                  width: 34,
                                                  height: 34,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue.shade50,
                                                    border: Border.all(color: Colors.blue),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Icon(Icons.add, color: Colors.blue, size: 18),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // ── GRAND TOTAL + CHECKOUT BAR ──────────────
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Grand Total", style: TextStyle(color: Colors.grey)),
                              Text(
                                "\$${grandTotal.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _showCheckoutDialog,
                            icon: Icon(Icons.shopping_bag_outlined, color: Colors.white),
                            label: Text(
                              "Checkout",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
