import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}


//loginPage


class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
               SizedBox(height: 200.0),
                      Text(
                'Holek',
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 172, 78, 212),
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(5.0, 5.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 166, 162, 162),
                    ),
                  ],
                ),
              ),
               SizedBox(height: 50.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color.fromARGB(255, 214, 203, 215),
                   prefixIcon: Icon(Icons.email),
                  prefixIconColor: Color.fromARGB(255, 222, 220, 220),
                
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Email Address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                    filled: true,
                  fillColor: Color.fromARGB(255, 214, 203, 215),
                  prefixIcon: Icon(Icons.lock),
                  prefixIconColor: Color.fromARGB(255, 222, 220, 220),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Not registered yet?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegistrationPage()),
                      );
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Processing Data')),
                    );
                     Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




//RegistrationPage



class RegistrationPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
      ),
      
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
              SizedBox(height: 90.0),
                      Text(
                'Holek',
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 172, 78, 212),
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(5.0, 5.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 166, 162, 162),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 5.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color.fromARGB(255, 214, 203, 215),
                  prefixIcon: Icon(Icons.person_2),
                  prefixIconColor: Color.fromARGB(255, 222, 220, 220),
                
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Full Name';
                }
                return null;
              },
            ),
            SizedBox(height: 15.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color.fromARGB(255, 214, 203, 215),
                  prefixIcon: Icon(Icons.email),
                  prefixIconColor: Color.fromARGB(255, 222, 220, 220),
                
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
                        SizedBox(height: 15.0),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color.fromARGB(255, 214, 203, 215),
                  prefixIcon: Icon(Icons.lock),
                  prefixIconColor: Color.fromARGB(255, 222, 220, 220),
              
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
                        SizedBox(height: 15.0),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
                filled: true,
                  fillColor: Color.fromARGB(255, 214, 203, 215),
                  prefixIcon: Icon(Icons.lock),
                  prefixIconColor: Color.fromARGB(255, 222, 220, 220),
                ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                return null;
              },
            ),
            SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Processing Data')),
                  );
                   Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
                }
              },
              child: Text('Register'),
              
            ),
          ],
        ),
      ),
    );
  }
}

// ...
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Holek',
          style: TextStyle(
            color: const Color.fromARGB(255, 172, 78, 212),
            fontSize: 30.0,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(45.0)),
                  borderSide: BorderSide(color:Color.fromARGB(255, 150, 60, 189)), 
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                SafeArea(
                  child: Text(
                    'Lets prepare your order ',
                    style: TextStyle(
                      color: Color.fromARGB(255, 150, 60, 189),
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Padding( 
                  padding: const EdgeInsets.only(top: 20.0), 
                  child: SingleChildScrollView(
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      children: List.generate(8, (index) {
                        return Center(
                          child: Container(
                            height: 160.0,
                            width: 160.0,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 214, 215, 216),
                              borderRadius: BorderRadius.circular(13.0),
                              border: Border.all(
                                color: const Color.fromARGB(255, 222, 218, 218),
                                width: 3.0,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Divider(color: Colors.white),
                                Text(
                                  'Name ${index + 1}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(
          size: 25.0,
          color: Color.fromARGB(255, 172, 78, 212),
        ),
        children: [
          SpeedDialChild(
            child: Icon(
              Icons.more_horiz,
              color: Color.fromARGB(255, 163, 54, 210), 
            ),
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  opaque: false, 
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
          SpeedDialChild(
            child: Icon(Icons.manage_accounts, color: Color.fromARGB(255, 163, 54, 210)),
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  opaque: false, // set to false
                  pageBuilder: (_, __, ___) => More(),
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
    );
  }
}


Widget createHalfPage(BuildContext context, String title, Color color, Color appBarColor) {
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
    child: FractionallySizedBox(
      alignment: Alignment.centerRight, 
      widthFactor: 0.8, 
      child: Container(
        color: color.withOpacity(0.7),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: appBarColor,
            title: Text(title),
          ),
        ),
      ),
    ),
  );
}

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return createHalfPage(context, 'More', Color.fromARGB(255, 235, 233, 234), const Color.fromARGB(255, 235, 233, 234)); //  AppBar color 
  }
}

class More extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return createHalfPage(context, 'Account', const Color.fromARGB(255, 235, 233, 234), const Color.fromARGB(255, 235, 233, 234)); //AppBar color 
  }
}
