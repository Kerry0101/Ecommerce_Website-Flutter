class Product {
  final String name;
  final String price;
  final String status;
  final String image;
  final String category;

  Product({
    required this.name,
    required this.price,
    required this.status,
    required this.image,
    required this.category,
  });
}

final List<Product> products = [
      Product(
      name: 'Aspire 3', 
      price: '\$99',
      status: 'Available', 
      image: 'assets/OIP.jpg', 
      category: 'Gadgets'),
      Product(
      name: 'ROG laptop (2025)', 
      price: '\$135',
      status: 'Available', 
      image: 'assets/ROG.jpg', 
      category: 'Gadgets'),
      Product(
      name: 'Xiaomi Mi 10T Pro', 
      price: '\$50',
      status: 'Available', 
      image: 'assets/Mi10t.jpg', 
      category: 'Smartphones'),
      Product(
      name: 'iPhone 16 Pro', 
      price: '\$75',
      status: 'Available', 
      image: 'assets/iPhone16Pro.jpg', 
      category: 'Smartphones'),
];