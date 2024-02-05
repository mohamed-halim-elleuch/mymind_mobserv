import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mymind_mobserv/firebase_options.dart';
import 'package:mymind_mobserv/screens/advice_list_screen.dart';
import 'package:mymind_mobserv/screens/appointment_list.dart';
import 'package:mymind_mobserv/screens/grandma_screen.dart';
import 'package:mymind_mobserv/screens/home_screen.dart';
import 'package:mymind_mobserv/screens/joke_list_screen.dart';
import 'package:mymind_mobserv/screens/login_screen.dart';
import 'package:mymind_mobserv/screens/positive_vibes_list_screen.dart';
import 'package:mymind_mobserv/screens/profile_screen.dart';
import 'package:mymind_mobserv/screens/registration_screen.dart';
import 'package:mymind_mobserv/screens/welcome_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  // Check if the user is already signed in
  User? user = FirebaseAuth.instance.currentUser;

  WidgetsFlutterBinding.ensureInitialized();


  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('mipmap/ic_launcher');


  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp(user: user));

}


class MyApp extends StatelessWidget {
  final User? user;

  const MyApp({Key? key, required this.user}) : super(key: key);
  @override

  Future<void> scheduleDailyNotification() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'you_can_name_it_whatever1',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );


    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Set the time for the daily notification (adjust as needed)
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Paris')); // Replace with your time zone
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime scheduledTime =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, 20, 01, 0);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Daily Notification Title',
      'Your daily notification message goes here.',
      scheduledTime,
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }


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
        '/grandma': (context) => GrandMaScreen(),


        // Other routes if needed
      },
      home: initialScreen,
      // ... other MaterialApp configurations
    );
  }
}
