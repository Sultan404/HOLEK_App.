import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cart/model/cart_model.dart';
import 'package:second/real/firestore_service.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:second/real/cart.dart'; 


class VendorFoodsPage extends StatefulWidget {
  final String vendorId;
  final FlutterCart flutterCart;

  VendorFoodsPage({required this.vendorId, required this.flutterCart});

  @override
  _VendorFoodsPageState createState() => _VendorFoodsPageState();
}

class _VendorFoodsPageState extends State<VendorFoodsPage> {
  late Future<List<QueryDocumentSnapshot<Object?>>> foods;
  late FlutterCart flutterCart;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    foods = FirestoreService().getFoodsByVendor(widget.vendorId);
    flutterCart = widget.flutterCart;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food for Vendor'),
      ),
      body: buildFoodsList(),
    );
  }

  Widget buildFoodsList() {
    return FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
      future: foods,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<QueryDocumentSnapshot<Object?>> data = snapshot.data ?? [];
          return GridView.builder(
            itemCount: data.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 197,
            ),
            itemBuilder: (context, i) {
              var itemData = data[i].data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  _showOrderDialog(context, itemData);
                },
                child: _buildCard(itemData),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildCard(Map<String, dynamic> itemData) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Image.network(
              itemData['image'] ?? 'hear 58',
              height: 100,
              width: 190,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8),
            Text(
              itemData['name'] ?? '',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              '${itemData['price'] ?? 0.0}' + ' \$',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDialog(BuildContext context, Map<String, dynamic> foodData) {
    int quantity = 1;
    double price = double.parse(foodData['price']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(foodData['name'] ?? ''),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(foodData['description'] ?? ''),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                        icon: Icon(Icons.remove),
                      ),
                      Text('$quantity'),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                  Text('Price: ${price * quantity ?? ''}'),
                  SizedBox(height: 10),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add item to the cart
                    flutterCart.addToCart(
                      productName:foodData['name'].toString(),
                      productId: foodData['id'].toString(),
                      unitPrice: price,
                      quantity: quantity,
                      productDetailsObject: foodData,
                      vendorID : foodData['vendorId'],
                    );
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: Text('Add to Cart'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');
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

  Future<void> _confirmOrder(
      Map<String, dynamic> foodData, String quantity) async {
    int qty = int.tryParse(quantity) ?? 0;
    
    if (qty > 0) {
      double price = double.parse(foodData['price'].toString());
      double totalAmount = qty * price;
      String customerId = FirebaseAuth.instance.currentUser!.uid;

      // Increment the order number
      await _incrementOrderNumber();

      // Get the updated order number
      DocumentSnapshot orderNumberDoc =
          await orderNumberCollection.doc('current_order_number').get();
      int orderNumber = orderNumberDoc.get('number');

      Map<String, dynamic> orderData = {
        'orderNumber': orderNumber,
        'customerId': customerId,
        'foodName': foodData['name'],
        'quantity': qty,
        'totalAmount': totalAmount,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Save the order data to Firestore
      await ordersCollection.add(orderData);
    } else {
      cath(e) {
        print(e);
      }
    }
  }
}
