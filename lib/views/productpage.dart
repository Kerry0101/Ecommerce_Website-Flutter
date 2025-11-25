import 'package:flutter/material.dart';
import 'package:ecommerce/models/productmodel.dart';

class Productpage extends StatefulWidget {
  const Productpage({super.key});

  @override
  State<Productpage> createState() => _ProductpageState();
}

enum OrderStatus { pending, toReceive, completed }

class Order {
  final Product product;
  final int quantity;
  OrderStatus status;
  Order({required this.product, required this.quantity, required this.status});
}

class _ProductpageState extends State<Productpage> {

    String _orderStatusText(OrderStatus status) {
      switch (status) {
        case OrderStatus.pending:
          return 'Pending';
        case OrderStatus.toReceive:
          return 'To Receive';
        case OrderStatus.completed:
          return 'Completed';
      }
    }

    Widget _buildOrders() {
      final tabs = ['All', 'Pending', 'To Receive', 'Completed'];
      List<Order> filteredOrders;
      if (ordersTabIndex == 0) {
        filteredOrders = orders;
      } else if (ordersTabIndex == 1) {
        filteredOrders = orders.where((o) => o.status == OrderStatus.pending).toList();
      } else if (ordersTabIndex == 2) {
        filteredOrders = orders.where((o) => o.status == OrderStatus.toReceive).toList();
      } else {
        filteredOrders = orders.where((o) => o.status == OrderStatus.completed).toList();
      }

      return Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              itemBuilder: (context, idx) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: Text(tabs[idx]),
                  selected: ordersTabIndex == idx,
                  onSelected: (selected) {
                    setState(() {
                      ordersTabIndex = idx;
                    });
                  },
                  selectedColor: Colors.red,
                  labelStyle: TextStyle(
                    color: ordersTabIndex == idx ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredOrders.isEmpty
                ? const Center(child: Text('No orders found.'))
                : ListView.separated(
                    itemCount: filteredOrders.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return ListTile(
                        leading: Image.asset(order.product.image, width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(order.product.name),
                        subtitle: Text('Qty: ${order.quantity} | Status: ${_orderStatusText(order.status)}'),
                        trailing: Text(order.product.price, style: const TextStyle(fontWeight: FontWeight.bold)),
                      );
                    },
                  ),
          ),
        ],
      );
    }


  int selectedIndex = 0;
  int currentNavIndex = 0;

  Set<Product> favoriteProducts = {};
  final Map<Product, int> cart = {};
  final List<Order> orders = [];
  int ordersTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Commerce App (CIANO TASK 8)'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _getCurrentTabWidget(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentNavIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            currentNavIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Orders"),
        ],
      ),
    );

  }

  Widget _getCurrentTabWidget() {
    if (currentNavIndex == 0) {
      return _buildHome();
    } else if (currentNavIndex == 1) {
      return _buildFavorites();
    } else if (currentNavIndex == 2) {
      return _buildCart();
    } else {
      return _buildOrders();
    }
  }

  Widget _buildHome (){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          const Text("Our Products", style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _categoryButton("All Products", 0),
            _categoryButton("Gadgets", 1),
            _categoryButton("Smartphones", 2),
          ],
        ),
        const SizedBox(height: 15),
        Expanded(child: _buildProductGrid())
      ],
    );
  }

  Widget _buildProductGrid(){
    List <Product> displayProducts;

    if (selectedIndex == 0){
      displayProducts = products;
    }else if (selectedIndex == 1){
      displayProducts = products.where((product) => product.category == 'Gadgets').toList();
    }else{
      displayProducts = products.where((product) => product.category == 'Smartphones').toList();
    }

    return GridView.builder(
      itemCount: displayProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.7,),
          itemBuilder: (context, index){
            final product = displayProducts[index];
            return _buildProductCard(product);
          },
    );

  }

  Widget _categoryButton(String title, int index){
    return ElevatedButton(
      onPressed: () => setState(() => selectedIndex = index),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedIndex == index ? Colors.red : Colors.grey[200],
        foregroundColor: selectedIndex == index ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
        ),
      ),child: Text (title),
    );
  }

  Widget _buildFavorites(){
    if (favoriteProducts.isEmpty){
      return const Center(
        child: Text ("No favorites products yet."),
      );
    }

    return GridView.builder(
        itemCount: favoriteProducts.length, 
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount (
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index){
            final product = favoriteProducts.elementAt(index);
            return _buildProductCard(product);
          },
        );
  }

  Widget _buildProductCard (Product product){
    final isFavorited = favoriteProducts.contains(product);
    

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    if (isFavorited) {
                      favoriteProducts.remove(product);
                    } else {
                      favoriteProducts.add(product);
                    }
                  });
                },
              ),
            ),
            Expanded(
              child: Image.asset(
                product.image,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      product.status,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      product.price,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_shopping_cart_outlined,
                    color: Colors.red,
                  ),
                  tooltip: 'Add to Cart',
                  onPressed: () {
                    _showAddToCartDialog(product);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddToCartDialog(Product product) {
    int quantity = 1;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add to Cart'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(product.name),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: quantity > 1
                            ? () => setState(() => quantity--)
                            : null,
                      ),
                      Text('$quantity', style: const TextStyle(fontSize: 18)),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() => quantity++),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      cart[product] = (cart[product] ?? 0) + quantity;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCart() {
    if (cart.isEmpty) {
      return const Center(
        child: Text('Your cart is empty.'),
      );
    }
    final cartItems = cart.entries.toList();
    double total = 0;
    for (final entry in cartItems) {
      final price = double.tryParse(entry.key.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      total += price * entry.value;
    }
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: cartItems.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final entry = cartItems[index];
                  final product = entry.key;
                  final quantity = entry.value;
                  return ListTile(
                    leading: Image.asset(product.image, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(product.name),
                    subtitle: Text('${product.price}  |  Qty: $quantity'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            setState(() {
                              if (cart[product]! > 1) {
                                cart[product] = cart[product]! - 1;
                              } else {
                                cart.remove(product);
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            setState(() {
                              cart[product] = cart[product]! + 1;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              cart.remove(product);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Total: ',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.extended(
            onPressed: () {
              if (cart.isEmpty) return;
              setState(() {
                cart.forEach((product, quantity) {
                  orders.add(Order(product: product, quantity: quantity, status: OrderStatus.pending));
                });
                cart.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Checkout process started!'),
                  action: SnackBarAction(
                    label: 'Orders',
                    onPressed: () {
                      setState(() {
                        currentNavIndex = 3;
                      });
                    },
                  ),
                ),
              );
            },
            icon: const Icon(Icons.payment),
            label: const Text('Checkout'),
            backgroundColor: const Color.fromARGB(255, 246, 105, 77),
          ),
        ),
      ],
    );
  }


}