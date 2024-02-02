import 'package:flutter/material.dart';
import '../data/grandma.dart';

class GrandMaScreen extends StatefulWidget {
  @override
  _GrandMaScreenState createState() => _GrandMaScreenState();
}

class _GrandMaScreenState extends State<GrandMaScreen> {
  List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4','Item 1', 'Item 2', 'Item 3', 'Item 4',];

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Color.fromRGBO(162, 230, 76, 0.5),
        title: Container(
          padding: EdgeInsets.all(10.0),

          child: const Text(
            'Grandma recipes',
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: GrandmaReceipes.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                // Toggle selected index
                selectedIndex = selectedIndex == index ? null : index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [SizedBox(height: 15,),
                  Container(

                    decoration: BoxDecoration(
                      color: Color.fromRGBO(162, 230, 76, 0.5), // Background color
                      borderRadius: BorderRadius.circular(30.0), // Border radius
                      boxShadow: [

                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Shadow color
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // Offset in the x, y direction
                          ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(

                            decoration: BoxDecoration(
                          color: Colors.white ,
                          borderRadius: BorderRadius.circular(20.0),),
                          child: ListTile(
                            title: Text(GrandmaReceipes[index].title),
                          ),
                        ),
                        if (selectedIndex == index) // Display details if selected
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(GrandmaReceipes[index].content),
                          ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
