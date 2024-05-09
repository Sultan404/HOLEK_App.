import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:second/homePage.dart';
import 'package:second/real/cart.dart';
import 'package:second/real/firestore_service.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<QueryDocumentSnapshot<Object?>>> vendors;
  late Future<List<QueryDocumentSnapshot<Object?>>> foods;
  late Future<String> _imageUrlFuture;
  late FlutterCart flutterCart;

  bool showVendors = true;
  final List<String> itemNames = [
    'ALL',
    'PIZZA',
    'BURGER',
    'SHAWARMA',
  ];

  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    vendors = _firestoreService.getVendorsData();
    foods = _firestoreService.getFoodsData();
    _imageUrlFuture = _getImageUrl();
    flutterCart = FlutterCart();
  }

  Future<String> _getImageUrl() async {
    String? userId = FirebaseAuth.instance.currentUser!.email;
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    return userSnapshot.get('image') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextButton.icon(
          icon: Icon(Icons.location_pin),
          label: Text(
            'Holek',
            style: TextStyle(
              color: const Color.fromARGB(255, 172, 78, 212),
              fontSize: 30.0,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LocationPage()),
            );
          },
        ),
        automaticallyImplyLeading: false,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.shopping_cart),
          //   onPressed: () {
          //     // Navigate to CartScreen when cart icon is tapped
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => CartScreen(flutterCart: flutterCart),
          //       ),
          //     );
          //   },
          // ),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("login", (route) => false);
              flutterCart.deleteAllCart();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '  HEY! 👋',
              style: TextStyle(
                color: Color.fromARGB(255, 117, 42, 149),
                fontSize: 30.0,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '  Lets prepare your order 🍽️ ',
              style: TextStyle(
                color: Color.fromARGB(255, 150, 60, 189),
                fontSize: 16.0,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '  Our trucks are waiting to serve you 🚚 ',
              style: TextStyle(
                color: Color.fromARGB(255, 150, 60, 189),
                fontSize: 16.0,
              ),
            ),
          ),
          Align(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: TextField(
                controller: _searchController,
                onChanged: (_) {
                  setState(() {
                    // Trigger rebuild to update the search results
                  });
                },
                decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(45.0)),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 150, 60, 189)),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    height: 0), // Add some space between the text and the list
                Container(
                  height: 50, // Set the height of the ListView
                  child: ListView.builder(
                    scrollDirection:
                        Axis.horizontal, // Make the ListView horizontal
                    itemCount: 4, // Replace with your actual item count
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (itemNames[index] == 'ALL') {
                              _searchController.text = '';
                            } else {
                              _searchController.text = itemNames[index];
                            }
                            ; // Update the text of the controller
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                                255, 172, 78, 212), // Set the color of the item
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(itemNames[index]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Foods'),
              Switch(
                value: showVendors,
                onChanged: (value) {
                  setState(() {
                    showVendors = value;
                  });
                },
              ),
              Text('vendors'),
            ],
          ),
          Expanded(
            child: Stack(
              children: [
                showVendors ? _buildVendorGridView() : _buildFoodGridView(),
                Positioned(
                  bottom: 16.0,
                  right: 16.0,
                  child: SpeedDial(
                    animatedIcon: AnimatedIcons.menu_close,
                    animatedIconTheme: IconThemeData(
                      size: 25.0,
                      color: Color.fromARGB(255, 172, 78, 212),
                    ),
                    children: [
                      SpeedDialChild(
                        child: Icon(Icons.shopping_cart,
                            color: Color.fromARGB(255, 163, 54, 210)),
                        onTap: () {
                          // Navigate to CartScreen when cart icon is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CartScreen(flutterCart: flutterCart),
                            ),
                          );
                        },
                      ),
                      SpeedDialChild(
                        child: Icon(Icons.manage_accounts,
                            color: Color.fromARGB(255, 163, 54, 210)),
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              opaque: false, // set to false
                              pageBuilder: (_, __, ___) => Account(),
                              transitionsBuilder: (_, anim, __, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(1, 0),
                                    end: Offset.zero,
                                  ).animate(anim),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorGridView() {
    return FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
      future: vendors,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<QueryDocumentSnapshot<Object?>> data = snapshot.data ?? [];
          data = _filterData(data);
          return GridView.builder(
            itemCount: data.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 197,
            ),
            itemBuilder: (context, i) {
              var docSnapshot = data[i];
              var itemData = docSnapshot.data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    'vendorFoods',
                    arguments: {
                      'vendorId': docSnapshot.id,
                      'flutterCart': flutterCart,
                    },
                  );
                },
                child: _buildCard(itemData, context),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildFoodGridView() {
    return FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
      future: foods,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<QueryDocumentSnapshot<Object?>> data = snapshot.data ?? [];
          data = _filterData(data);
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
                  _showOrderDialog(itemData);
                },
                child: _buildCard(itemData, context),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildCard(Map<String, dynamic> itemData, BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Image.network(
                  itemData['image'] ?? 'hear 137',
                  height: 100,
                  width: 190,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 8),
                Text(
                  itemData['name'] ?? '',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                if (itemData['price'] != null)
                  Text(
                    '${itemData['price']} \$' ?? "",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<QueryDocumentSnapshot<Object?>> _filterData(
    List<QueryDocumentSnapshot<Object?>> data,
  ) {
    String searchText = _searchController.text.toLowerCase().trim();
    if (searchText.isNotEmpty) {
      return data.where((doc) {
        Map<String, dynamic> itemData = doc.data() as Map<String, dynamic>;
        String itemName = itemData['name'].toString().toLowerCase();
        return itemName.contains(searchText) ||
            _isArabicMatch(itemName, searchText);
      }).toList();
    }
    return data;
  }

  bool _isArabicMatch(String itemName, String searchText) {
    final arabicRange = RegExp(r'[\u0600-\u06FF\s]');
    String arabicItemName = itemName.split('').where((char) {
      return arabicRange.hasMatch(char);
    }).join('');
    return arabicItemName.contains(searchText);
  }

  void _showOrderDialog(Map<String, dynamic> foodData) {
    int quantity = 1;
    double price = double.parse(foodData['price'] ?? '0');

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
                  
                  Text(foodData['Description'] ?? 'eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee'),
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
                  Text('Price: ${price * quantity} \$'),
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
                      productName: foodData['name'].toString(),
                      vendorID: foodData['vendorId'].toString(),
                      productId: foodData['id'].toString(),
                      unitPrice: price,
                      quantity: quantity,
                      productDetailsObject: foodData,
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
}

class LocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
      ),
      body: Center(
        child: Text(
          'This is the Location Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class Account extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Color.fromARGB(255, 136, 37, 186),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 40.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter your Username',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color.fromARGB(255, 255, 253, 255),
                prefixIcon: Icon(Icons.person_2),
                prefixIconColor: Color.fromARGB(255, 222, 220, 220),
              ),
            ),
            SizedBox(height: 15.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter current Password',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color.fromARGB(255, 255, 253, 255),
                prefixIcon: Icon(Icons.lock),
                prefixIconColor: Color.fromARGB(255, 222, 220, 220),
              ),
            ),
            SizedBox(height: 15.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter new Password',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color.fromARGB(255, 255, 253, 255),
                prefixIcon: Icon(Icons.lock),
                prefixIconColor: Color.fromARGB(255, 222, 220, 220),
              ),
            ),
            SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Changes Saved')),
                  );
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Container(
                          color: const Color.fromARGB(255, 185, 72, 72),
                          child: MyHomePage(),
                        ),
                      ));
                }
              },
              child: Text('Confirm Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
