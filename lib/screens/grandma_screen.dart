import 'package:flutter/material.dart';
import '../data/grandma.dart';

class GrandMaScreen extends StatefulWidget {
  @override
  _GrandMaScreenState createState() => _GrandMaScreenState();
}

class _GrandMaScreenState extends State<GrandMaScreen> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Color.fromRGBO(162, 230, 76, 0.5),
        title: Container(
          padding: EdgeInsets.all(15.0),
          child: const Text(
            'Grandma recipes',
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/grandma.jpeg', // Replace with your image path
            height: 200.0, // Adjust the height as needed
            fit: BoxFit.cover, // Adjust the fit property as needed
          ),
          Expanded(
            child: ListView.builder(
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
                      children: [
                        SizedBox(height: 25,),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(162, 230, 76, 0.5),
                            borderRadius: BorderRadius.circular(40.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ListTile(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            GrandmaReceipes[index].title,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(
                                          selectedIndex == index
                                              ? Icons.expand_less
                                              : Icons.expand_more,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (selectedIndex == index)
                                Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    GrandmaReceipes[index].content,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black87,
                                    ),
                                  ),
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
          ),
        ],
      ),
    );
  }
}
