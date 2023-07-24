class Order {
  int? id;
  double kgPrice;
  double totalPrice;
  double totalWeight;
  String? orderDate;

  Order({
    this.id,
    required this.kgPrice,
    required this.totalPrice,
    required this.totalWeight,
    this.orderDate,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: int.parse(json['id']),
        kgPrice: double.parse(json['kg_price']),
        totalPrice: double.parse(json['total_price']),
        totalWeight: double.parse(json['total_weight']),
        orderDate: json['order_date'],
      );
}
