import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mymind_mobserv/firebase_options.dart';
import 'package:mymind_mobserv/screens/advice_list_screen.dart';
import 'package:mymind_mobserv/screens/appointment_list.dart';
import 'package:mymind_mobserv/screens/home_screen.dart';
import 'package:mymind_mobserv/screens/joke_list_screen.dart';
import 'package:mymind_mobserv/screens/login_screen.dart';
import 'package:mymind_mobserv/screens/positive_vibes_list_screen.dart';
import 'package:mymind_mobserv/screens/profile_screen.dart';
import 'package:mymind_mobserv/screens/registration_screen.dart';
import 'package:mymind_mobserv/screens/welcome_screen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  // Check if the user is already signed in
  User? user = FirebaseAuth.instance.currentUser;

  runApp(MyApp(user: user));

}

class MyApp extends StatelessWidget {
  final User? user;

  const MyApp({Key? key, required this.user}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    Widget initialScreen = user != null ? const HomeScreen() : const WelcomeScreen();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: user != null ? '/home' : '/welcome',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/profile': (context) => const ProfileScreen(),
        'register': (context) => const RegistrationScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/advice_list': (context) => const AdviceListScreen(),
        '/joke_list': (context) => const JokeListScreen(),
       '/appointment_list': (context) => const AppointmentListScreen(appointments: [],),
       '/positive_vibes_list': (context) => const PositiveVibesListScreen(),
        '/home': (context) => const HomeScreen(),

        // Other routes if needed
      },
      home: initialScreen,
      // ... other MaterialApp configurations
    );
  }
}
