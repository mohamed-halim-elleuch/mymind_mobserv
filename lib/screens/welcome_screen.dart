
import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Message {
  final String category;
  final String emotion;
  final String content;

  Message({
    required this.category,
    required this.emotion,
    required this.content,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      category: json['Category'],
      emotion: json['Emotion'],
      content: json['Content'],
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person), // Change to the appropriate icon for sign-in
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [

            Positioned(
              left: screenWidth * 0.11,
              top: screenHeight * 0.075,
              child: Circle(color: Color.fromARGB(202, 241, 239, 108), radius: 60.0),
            ),
            Positioned(
              left: screenWidth * 0.35,
              top: screenHeight * 0.115,
              child: Circle(color: Color.fromARGB(193, 151, 232, 239), radius: 60.0),
            ),
            Positioned(
              left: screenWidth * 0.59,
              top: screenHeight * 0.06,
              child: Circle(color: Color.fromARGB(192, 252, 194, 223), radius: 60.0),
            ),
            const Positioned(
              left: 25.0, // X-coordinate
              top: 80.0, // Y-coordinate
              child: Text("We're thrilled to support you on your \n journey to wellness !",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  // Adjust the font size as needed
                ),),
            ),

            Positioned(
              left: -110.0, // Adjust the X-coordinate as needed
              top: 300.0, // Adjust the Y-coordinate as needed
              child: CircularCardHand(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text(
                'Skip',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // You can add additional buttons or content here
        ],
      ),
    );
  }
}


class Circle extends StatelessWidget {
  final Color color;
  final double radius;

  Circle({required this.color, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}




class CardWidget extends StatelessWidget {
  final String text;
  final double angle;
  final Color color;
  final IconData icon;

  CardWidget({required this.text, required this.angle, this.color = Colors.greenAccent,required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height:350,
      decoration: ShapeDecoration(
        color: color,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))
        ),shadows: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
      ),

      alignment: Alignment.center,



      padding: EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              icon, // Change to the desired icon
              color: const Color(0xffFFCC4D),
              size: 24.0,
            ),
          ),
          Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 16.0),
              
            ),
          ),
        ],
      ),

    );
  }
}

class CircularCardHand extends StatefulWidget {
  @override
  CircularCardHandState createState() => CircularCardHandState();
}

class CircularCardHandState extends State<CircularCardHand> {
  List<Map<String, dynamic>> cardTexts = [{'text':'','color':const Color(0xffD1F3A5),'icon':Icons.check_circle_rounded},
    {'text':'','color':const Color(0xffDCF0FF),'icon':Icons.favorite_rounded},
    {'text':"",'color':const Color(0xffFFC4F8),'icon':Icons.face_rounded}
  ];
  late int selectedMoodIndex = -1;
  late String selectedEmotion = '';
  late List<Message> messages;
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void updateCardContent(int moodIndex) {
    setState(() {
      selectedMoodIndex = moodIndex;

      switch (selectedMoodIndex) {
        case 0:
          selectedEmotion = 'Happy';
          break;
        case 1:
          selectedEmotion = 'Sad';
          break;
        case 2:
          selectedEmotion = 'Motivated';
          break;
        case 3:
          selectedEmotion = 'Stressed';
          break;
      }

      List<Message> filteredMessages = messages.where((msg) => msg.emotion == selectedEmotion).toList();

      Message randomJoke = _getRandomMessageByCategory(filteredMessages, 'Joke');
      Message randomPositiveVibe = _getRandomMessageByCategory(filteredMessages, 'Positive Vibes');
      Message randomAdvice = _getRandomMessageByCategory(filteredMessages, 'Advice');

      cardTexts = [
        {
          'text': randomAdvice.content,
          'color': const Color(0xffD1F3A5),
          'icon': Icons.check_circle_rounded,
        },
        {
          'text': randomPositiveVibe.content,
          'color': const Color(0xffDCF0FF),
          'icon': Icons.favorite_rounded,
        },
        {
          'text': randomJoke.content,
          'color': const Color(0xffFFC4F8),
          'icon': Icons.face_rounded,
        },
      ];
    });
  }


  Future<void> initializeData() async {
    messages = await readMessages();
  }

  Message _getRandomMessageByCategory(List<Message> messages, String category) {
    List<Message> categoryMessages = messages.where((msg) => msg.category == category).toList();
    return categoryMessages.isNotEmpty ? categoryMessages[Random().nextInt(categoryMessages.length)] : Message(category: '', emotion: '', content: '');
  }


  Future<List<Message>> readMessages() async {
    try {
      String content = await rootBundle.loadString('assets/converted_data.json');
      List<dynamic> jsonData = json.decode(content);
      List<Message> messages = jsonData.map((json) => Message.fromJson(json)).toList();

      return messages;
    } catch (e) {
      print('Error reading JSON file: $e');
      return [];
    }
  }


  // List<Map<String, dynamic>> cardTexts = [{'text':'Stay connected with friends and family. Social support is crucial for mental well-being','color':const Color(0xffD1F3A5),'icon':Icons.check_circle_rounded},
  //   {'text':'Your are capable of amazing things. \nBelieve in yourself and your potential today.','color':const Color(0xffDCF0FF),'icon':Icons.favorite_rounded},
  //   {'text':"- why dark is with k not with c ? \n- Because you can't see in the dark",'color':const Color(0xffFFC4F8),'icon':Icons.face_rounded}
  // ];
  int i = 2;
  @override
  Widget build(BuildContext context) {
    return Center(
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [selectedMoodIndex == -1
            ? Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Row( mainAxisAlignment: MainAxisAlignment.center,
                children: [const SizedBox(width:160.0),Text("How do you feel today?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                // Adjust the font size as needed
              ),
            )
            ]
              ),
            
            const SizedBox(height:30.0),
            Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [const SizedBox(width:160.0),_buildCircularButton('Happy', Colors.blue,0, x: 50.0, y: 50.0),
                  const SizedBox(width:50.0),
                  _buildCircularButton('Sad', Colors.red,1, x: 150.0, y: 200.0),]),
            const SizedBox(height:50.0),
            Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [const SizedBox(width:160.0),_buildCircularButton('Motivated', Colors.green,2, x: 300.0, y: 50.0),
                  const SizedBox(width:50.0),
                  _buildCircularButton('Stressed', Colors.yellow,3, x: 350.0, y: 200.0),])

          ],
        )
            :SizedBox(
                height: 400,
                child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:List.generate(
          3,
              (index) {
            double cardAngle = 1.99* pi * index / 3.96;
            double rotation = -0.2*(index-1);

            return Transform(
              alignment: Alignment.bottomRight,
              transform: Matrix4.identity()
                ..translate(202.0 * cos(cardAngle), 0.0 * sin(cardAngle))
                ..rotateZ(rotation),

              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: GestureDetector(
                  key: ValueKey<int>(i),
                  onTap: () {
                    // Handle tap to change content here
                    setState(() {
                      // Update the text content
                      i = (i-1)%3;
                    });
                  },
                  child: CardWidget(
                    text: cardTexts[i]['text'],
                    angle: rotation,
                    color: cardTexts[(index+i)%3]['color'],
                    icon: cardTexts[(index+i)%3]['icon'],
                  ),
                ),
              ),
            );
          },
        ),
                ),
    ),
]
      ),
    );
  }

  Widget _buildCircularButton(String label, Color color , int index, {required double x, required double y}) {
    return Positioned(
      left: x,
      top: y,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedMoodIndex = index;
            updateCardContent(selectedMoodIndex);
          });
        },
        // child: Container(
        //   width: 120,
        //   height: 150,
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //     color: color,
        //   ),
        //   child: Center(
        //     child: Text(
        //       label,
        //       style: TextStyle(
        //         color: Colors.white,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        // ),
        child:Container(
        //width: 130,
        //height: 150,
        decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        ),
        child:

        CircleAvatar(
        radius: 60.0, // Adjust the radius as needed
        backgroundImage: AssetImage("assets/${label}.jpeg"), // Replace with your image path
        ),



    )
      ),
    );
  }
}

