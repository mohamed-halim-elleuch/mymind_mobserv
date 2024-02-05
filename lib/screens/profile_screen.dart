import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ProfileScreen extends StatefulWidget {

const ProfileScreen({super.key});

@override
ProfileScreenState createState() => ProfileScreenState();
}


class ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> getUserName() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        return user.displayName;
      } else {
        return null; // User is not authenticated
      }
    } catch (e) {
      print("Error fetching user name: $e");
      return null;
    }
  }
  bool isLoggingOut = false;
//onPressed: () => _signOut(context)
  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, '/login');
  }


int selectedIndex = 0;
static const List<Widget> _widgetOptions = <Widget>[
  Text('Icon 1'),
  Text('Icon 2'),
  Text('Icon 3'),
  Text('Icon 4'),
];

void _onItemTapped(int index) {
  setState(() {
    selectedIndex = index;
  });
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
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.settings_rounded),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                _signOut(context);
              }
            },
          ),
        ],

      ),
      body:
      Column(
        children: [
          SizedBox(
            height: 250,
            child: Stack(
              children: [
                // Custom background with four curved lines
                CustomPaint(
                  painter: CurvePainter(),
                  child: Container(),
                ),

                // Profile content
                const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Image inside a circle
                      CircleAvatar(
                        radius: 110.0, // Adjust the radius to make the circle larger
                        backgroundColor: Color(0xffF3F1FF), // Set the background color of the circle
                        child: CircleAvatar(
                          radius: 90.0,
                          backgroundImage: AssetImage('assets/emma.png'), // Replace with your image
                        ),
                      ),
                      SizedBox(height: 16.0),


                      // Add other profile information here
                    ],
                  ),
                ),
              ],
            ),
          ),
      FutureBuilder<String?>(
      future: getUserName(),
  builder: (context, snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
  return CircularProgressIndicator(); // Loading indicator while fetching the user name
  // Handle error
  } else { return
           Text(snapshot.data!,style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),);}}),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.stars_rounded,
                color: Colors.yellow,
                size: 24.0,
              ),
              Text(
                'Advanced',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          const CirclesWithPointsBox(),

          const IconTextCard(
            firstIcon: Icons.storage_rounded,
            text: 'Your next challenge',
            subtext: '30 days',
            secondIcon: Icons.arrow_circle_right_rounded,
          ),
        ],),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.blue, // Set the background color
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)), // Add round border
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded),
              label: 'Challenges',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note_sharp),
              label: 'Appointment',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.food_bank_outlined),
              label: 'recipe',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_add_rounded),
              label: 'Reflection',
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.cyan,
          onTap: _onItemTapped,



        ),
      )
  );
}
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final path1 = Path()
      ..moveTo(0, size.height * 0.2)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0, size.width * 0.5, size.height * 0.45)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.72, size.width, size.height * 0.28);

    final path2 = Path()
      ..moveTo(0, size.height * 0.28)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.02, size.width * 0.5, size.height * 0.47)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.74, size.width, size.height * 0.36);

    final path3 = Path()
      ..moveTo(0, size.height * 0.36)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.04, size.width * 0.5, size.height * 0.49)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.76, size.width, size.height * 0.44);

    final path4 = Path()
      ..moveTo(0, size.height * 0.44)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.06, size.width * 0.5, size.height * 0.51)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.78, size.width, size.height * 0.52);

    final path5 = Path()
      ..moveTo(0, size.height * 0.52)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.08, size.width * 0.5, size.height * 0.53)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.8, size.width, size.height * 0.6);


    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
    canvas.drawPath(path3, paint);
    canvas.drawPath(path4, paint);
    canvas.drawPath(path5, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

}

class CirclesWithPointsBox extends StatelessWidget {
  const CirclesWithPointsBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xffF3F1FF),
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          CircleWithPoints(radius: 90.0, points: 10),
        ],
      ),
    );
  }
}

class CircleWithPoints extends StatelessWidget {
  final double radius;
  final int points;

  const CircleWithPoints({super.key, required this.radius, required this.points});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: const Color(0x55f5F5F5), // Set the background color of the outer circle
          child:  CustomPaint(
            painter: DashedCirclePainter(radius: radius-20),
            child: CircleAvatar(
              radius: radius - 20,
              backgroundColor: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ("$points"),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue, // Set the color of the points text
                    ),
                  ),
                  const Text(
                    ("Points"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blue, // Set the color of the points text
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }


}

class DashedCirclePainter extends CustomPainter {
  final double radius;


  DashedCirclePainter({
    required this.radius,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xff187211)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final double radius = this.radius;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Draw the dashed circle
    double angle = 0;
    while (angle < 2 * 3.14) {
      final double x1 = centerX + radius * cos(angle);
      final double y1 = centerY + radius * sin(angle);
      angle += 0.1; // Adjust the value to control the length of dashes
      final double x2 = centerX + radius * cos(angle);
      final double y2 = centerY + radius * sin(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
      angle += 0.1; // Adjust the value to control the length of gaps
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}


class IconTextCard extends StatelessWidget {
  final IconData firstIcon;
  final String text;
  final String subtext;
  final IconData secondIcon;

  const IconTextCard({super.key,
    required this.firstIcon,
    required this.text,
    required this.subtext,
    required this.secondIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xffD2F1FB),
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            firstIcon,
            size: 40.0,
          ),
          const SizedBox(width: 25.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                subtext,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black38,
                ),
              ),
            ],
          ),
          const Spacer(), // Adds space between the two sets of icons
          Icon(
            secondIcon,
            size: 35.0,

          ),
        ],
      ),
    );
  }
}








