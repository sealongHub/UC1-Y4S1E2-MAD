class Orders {
  int? id;
  int? bookId;
  int? qty;
  double? amount;
  String? phoneNumber;
  int? discount;
  double? totalAmount;

  Orders({
    this.id,
    this.bookId,
    this.qty,
    this.amount,
    this.phoneNumber,
    this.discount,
    this.totalAmount,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "book_id": bookId,
        "qty": qty,
        "amount": amount,
        "phone_number": phoneNumber,
        "discount": discount,
        "total_amount": totalAmount,
      };

  factory Orders.fromMap(Map<String, dynamic> map) {
    return Orders(
      id: map["id"],
      bookId: map["book_id"],
      qty: map["qty"],
      amount: (map["amount"] as num?)?.toDouble(),
      phoneNumber: map["phone_number"],
      discount: map["discount"],
      totalAmount: (map["total_amount"] as num?)?.toDouble(),
    );
  }
}
