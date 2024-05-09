import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_cart/model/cart_model.dart';
import 'package:second/copm/button.dart';
import 'package:second/real/food.dart';

class CartScreen extends StatefulWidget {
  final FlutterCart flutterCart;

  CartScreen({required this.flutterCart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Color.fromARGB(255, 98, 16, 153),
      ),
      body: _buildCartContents(),
    );
  }

  Widget _buildCartContents() {
    List<CartItem> cartItems = widget.flutterCart.cartItem;

    if (cartItems.isEmpty) {
      return Center(
        child: Text('Your cart is empty.'),
      );
    }

    void clearCart() {
      widget.flutterCart.deleteAllCart();
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              CartItem cartItem = cartItems[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 4.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cartItem.productName ?? ''),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (cartItem.quantity > 1) {
                                setState(() {
                                  cartItem.quantity--;
                                });
                              }
                            },
                            icon: Icon(Icons.remove),
                          ),
                          Text('${cartItem.quantity}'),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                cartItem.quantity++;
                              });
                            },
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Price: ${cartItem.unitPrice * cartItem.quantity}'),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            widget.flutterCart.deleteItemFromCart(index);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (cartItems.isNotEmpty) {
              _confirmOrder(
                cartItems,
              );
            }
          },
          child: Text('Confirm the order'),
        ),
      ],
    );
  }

  CollectionReference vendors =
      FirebaseFirestore.instance.collection('vendors');
  final CollectionReference orderNumberCollection =
      FirebaseFirestore.instance.collection('order_numbers');

  Future<void> _incrementOrderNumber() async {
    // Get the current order number
    DocumentSnapshot orderNumberDoc =
        await orderNumberCollection.doc('current_order_number').get();
    int currentOrderNumber =
        orderNumberDoc.exists ? orderNumberDoc.get('number') : 0;

    // Increment the order number
    int nextOrderNumber = currentOrderNumber + 1;

    // Update the order number in Firestore
    await orderNumberCollection
        .doc('current_order_number')
        .set({'number': nextOrderNumber});
  }

  Future<void> _confirmOrder(List<CartItem> foodData) async {
    try {
      // Ensure user is authenticated
      if (FirebaseAuth.instance.currentUser != null) {
        String customerId = FirebaseAuth.instance.currentUser!.uid;

        // Increment the order number
        await _incrementOrderNumber();

        // Group items by vendor ID
        Map<String, List<CartItem>> groupedItems = {};
        foodData.forEach((item) {
          groupedItems.putIfAbsent(item.vendorID ?? '', () => []).add(item);
        });

        // Iterate over grouped items
        for (var entry in groupedItems.entries) {
          String vendorId = entry.key;
          List<CartItem> items = entry.value;
          for (var item in items) {
            print(item.quantity);
          }
          List<Food> foods = items
              .map((item) => Food(
                    id: item.productId,
                    name: item.productName,
                    price: item.unitPrice.toString(),
                    quantity: item.quantity,
                    vendorId: item.vendorID,
                    image: '',
                  ))
              .toList();

          // Get the current order number
          DocumentSnapshot orderNumberDoc =
              await orderNumberCollection.doc('current_order_number').get();
          int orderNumber = orderNumberDoc.get('number');

          // Save the order data to Firestore
          await FirebaseFirestore.instance
              .collection('vendors')
              .doc(vendorId)
              .collection('orders')
              .add({
            'orderNumber': orderNumber,
            'customerId': customerId,
            'foods': foods.map((food) => food.toMap()).toList(),
            'timestamp': FieldValue.serverTimestamp(),
            'vendorID': vendorId,
          });
        }
      } else {
        // Handle authentication issue
        print('User not authenticated');
      }
    } catch (e) {
      // Handle any errors
      print(e);
    }
  }
}
