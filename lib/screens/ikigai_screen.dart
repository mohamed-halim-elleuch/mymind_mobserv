import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mymind_mobserv/screens/all_challenges_screen.dart';
import 'package:mymind_mobserv/screens/home_screen.dart';


class IkigaiDiagram extends StatelessWidget {
  final TextEditingController question1Controller = TextEditingController();
  final TextEditingController question2Controller = TextEditingController();
  final TextEditingController question3Controller = TextEditingController();
  final TextEditingController question4Controller = TextEditingController();
  Future<void> saveResponsesToDatabase() async {
    // Get responses from text controllers
    String response1 = question1Controller.text;
    String response2 = question2Controller.text;
    String response3 = question3Controller.text;
    String response4 = question4Controller.text;

    // Create a map with the responses
    Map<String, dynamic> responsesMap = {
      'question1': response1,
      'question2': response2,
      'question3': response3,
      'question4': response4,
    };

    // Save the map to the Firestore database
    await FirebaseFirestore.instance.collection('ikigai_responses').add(responsesMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ikigai Diagram'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0,horizontal: 0.0),
                child: CustomPaint(
                  painter: IkigaiPainter(context),
                  child: Container(
                    width: 300,
                    height: 300,
                    child: const Center(
                      child: Text(
                        'Ikigai',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _buildTextField('What are you good at?', false, question1Controller,const Color.fromRGBO(236, 214, 203, 0.2)),
              _buildTextField('What do you love?', false, question2Controller,const Color.fromRGBO(236, 214, 203, 0.2)),
              _buildTextField('What does the world need?', true, question3Controller,const Color.fromRGBO(236, 214, 203, 0.2)),
              _buildTextField('What can you be paid for?', true, question4Controller,const Color.fromRGBO(236, 214, 203, 0.2)),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: 45,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffF5F5F5)),
                    foregroundColor: MaterialStateProperty.all<Color>(const Color(0xff601D87)),
                    elevation: MaterialStateProperty.all<double>(8.0),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.greenAccent,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Your responses are being submitted...',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.blueAccent,
                        duration: Duration(seconds: 3),
                        action: SnackBarAction(
                          label: 'DISMISS',
                          textColor: Colors.white,
                          onPressed: () {
                            // Add any action you want when the user presses the action button
                          },
                        ),
                      ),
                    );

                    // Save responses to the database
                    await saveResponsesToDatabase();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'SUBMIT',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
                SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}

class IkigaiPainter extends CustomPainter {
  final BuildContext context;

  IkigaiPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final double circleRadius = 100;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Colors inspired by Ikigai diagrams
    const Color loveColor = Color.fromRGBO(250, 151, 108, 0.5647058823529412);
    const Color skillsColor = Color.fromRGBO(133, 181, 245, 0.5803921568627451);
    const Color worldNeedsColor = Color.fromRGBO(
        151, 245, 133, 0.5019607843137255);
    const Color paidForColor = Color.fromRGBO(255, 161, 255, 0.6627450980392157);

    // Draw the left circle
    drawCircle(canvas, Offset(centerX - 2.3 * circleRadius / 3, centerY), circleRadius, loveColor, "Love");

    // Draw the right circle
    drawCircle(canvas, Offset(centerX + 2.3 * circleRadius / 3, centerY), circleRadius, skillsColor, "Skills");

    // Draw the top circle
    drawCircle(canvas, Offset(centerX, centerY - 2.3 * circleRadius / 3), circleRadius, worldNeedsColor, "World Needs");

    // Draw the bottom circle
    drawCircle(canvas, Offset(centerX, centerY + 2.3 * circleRadius / 3), circleRadius, paidForColor, "Paid For");

    // Draw text in non-intersecting areas
    drawText(canvas, 'What are you \n good at?', centerX - circleRadius - 20, centerY, circleRadius, Colors.black);
    drawText(canvas, 'What does \n the world need?', centerX + circleRadius + 20, centerY, circleRadius, Colors.black);
    drawText(canvas, 'What do you love?', centerX, centerY - 2 * circleRadius / 3 - circleRadius / 2, circleRadius, Colors.black);
    drawText(canvas, 'What can you be paid for?', centerX, centerY + circleRadius / 2 + circleRadius / 2, circleRadius, Colors.black);
  }

  void drawCircle(Canvas canvas, Offset center, double radius, Color color, String text) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);

    InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailPage(color: color, text: text)),
        );
      },
      child: Container(
        width: radius * 2,
        height: radius * 2,
      ),
    );
  }

  void drawText(Canvas canvas, String text, double x, double y, double circleRadius, Color color) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final double textX = x - textPainter.width / 2;
    final double textY = y - textPainter.height / 2;

    textPainter.paint(canvas, Offset(textX, textY));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DetailPage extends StatelessWidget {
  final Color color;
  final String text;

  DetailPage({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        title: Text(text),
      ),
      body: Center(
        child: Text(
          'This is the $text page',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

Widget _buildTextField(String label, bool obscureText, TextEditingController controller,color) {
  return Column(
    children: [
      Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
      const SizedBox(height: 5.0),
      TextFormField(
        controller: controller,
        obscureText: false,
        decoration: InputDecoration(
          labelText: "Enter your answer",

          labelStyle:  TextStyle(
            color: Colors.grey.shade600,
          ),
          filled: true,
          fillColor: color,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
      const SizedBox(height: 25.0),
    ],
  );


}
