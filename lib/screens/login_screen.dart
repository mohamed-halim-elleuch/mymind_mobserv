import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mymind_mobserv/screens/home_screen.dart';
import 'package:mymind_mobserv/screens/profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
           

      // User login successful
      if (kDebugMode) {
        print("User logged in: ${userCredential.user?.email}");
      }

            // Navigate to the profile page after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );

    } catch (e) {
      if (kDebugMode) {
        print("Error during login: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              SizedBox(
                width: 150.0,
                height: 150.0,

                // You can replace the child with your logo/image widget
                child: Center(
                  child: Image.asset(
                    'assets/logo.png', // Replace with your image asset path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              // Username field
              const Row(
                children: [

                  Text(
                    'Email',
                    style: TextStyle(
                        color: Colors.blue, // Change label color as needed
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              const SizedBox(height: 5.0),

              // Username field
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.blueAccent,
                  ),
                  filled: true,
                  fillColor: const Color(0x55F7A5ED),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              const SizedBox(height: 35.0),


              const Row(
                children: [

                  Text(
                    'Password',
                    style: TextStyle(
                        color: Colors.blue, // Change label color as needed
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ), const SizedBox(height: 5.0),
              // Password field
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.blue,
                  ),



                  labelStyle: const TextStyle(
                    color: Colors.blueAccent, // Change label color as needed
                  ),
                  filled: true,
                  fillColor: const Color(0x55F7A5ED), // Change background color as needed
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),

                ),
              ),
              const SizedBox(height: 10.0),

              // Forget password link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Handle forget password action
                  },
                  child: const Text('Forgot Password?',style: TextStyle(
                      color: Colors.blue, // Change label color as needed
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0
                  ),),
                ),
              ),
              const SizedBox(height: 20.0),

              // Sign In button
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:  MaterialStateProperty.all<Color>(const Color(0xffF5F5F5)),
                    minimumSize: MaterialStateProperty.all(const Size(double.infinity / 2, 50.0)),
                  ),
                  onPressed: login,
                  child: const Text('SIGN IN'),
                ),
              ),
              const SizedBox(height: 20.0),

              // Sign Up button
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:  MaterialStateProperty.all<Color>(const Color(0xffF5F5F5)),
                    minimumSize: MaterialStateProperty.all(const Size(double.infinity / 2, 50.0)),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'register');
                  },
                  child: const Text('CREATE AN ACCOUNT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
