import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.06),
              // User Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // User Image and Name
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigate to the profile page
                          Navigator.pushNamed(context, '/grandma');
                        },
                        child: const CircleAvatar(
                          radius: 30.0,
                          backgroundImage: AssetImage(
                              "assets/emma.png"), // Replace with your image
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      GestureDetector(
                        onTap: () {
                          // Navigate to the profile page
                          Navigator.pushNamed(context, '/profile');
                        },
                        child: const Text(
                          'Emma', // Replace with the user's name
                          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  // Icon in the other corner
                  const Icon(
                    Icons.lightbulb_outline, // Replace with the desired icon
                    size: 30.0,
                    color: Colors.black,
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              // Colored Box with Round Image and Text "IKIGAI"
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffAC9FFE),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.all(20.0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30.0,
                      backgroundImage: AssetImage(
                          'assets/ikigai.png'), // Replace with your image
                    ),
                    SizedBox(height: 10.0, width: 100,),
                    Text(
                      'IKIGAI',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50.0),
              Row(
                children: [
                  Expanded(
                    child: buildCard('Challenges', Icons.favorite_rounded, const Color(0xffF7A5ED)),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: buildCard('Appointment', Icons.event_note_sharp, const Color(0xbbFCA629)),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: buildCard('Grandma recipe', Icons.food_bank_outlined, const Color(0xaaA2E64C)),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: buildCard('Reflection', Icons.bookmark_add_rounded, const Color(0xccCEEAFF)),
                  ),
                ],
              ),
            ],
          ),
        ),

      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.blue, // Set the background color
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)), // Add round border
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
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
          unselectedItemColor: const Color(0xffAC9FFE),
          onTap: _onItemTapped,



        ),
      ),
    );
  }
}

Widget buildCard(String text, IconData icon, Color color) {
  return Container(
    width: 100,
    height: 240,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(30.0),
    ),
    padding: const EdgeInsets.all(35.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Icon(
              icon,
              size: 40.0,
              color: Colors.white,

            ),const SizedBox(height: 10.0),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),


        const Icon(
          Icons.add_circle_rounded,
          size: 40.0,
          color: Colors.black,
        ),
      ],
    ),
  );
}

