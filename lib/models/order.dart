class Order {
  final List<String> productNames;
  final String address;
  final String email;

  Order({required this.productNames, required this.address, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'productNames': productNames,
      'address': address,
      'email': email,
    };
  }
}
