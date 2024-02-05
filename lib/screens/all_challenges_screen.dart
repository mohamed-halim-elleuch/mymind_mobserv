import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import '../data/all_challenges.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';

import '../data/all_challenges.dart';
import 'challenges_screen.dart';

class AllChallengesScreen extends StatefulWidget {
  @override
  _AllChallengesScreenState createState() => _AllChallengesScreenState();
}

class _AllChallengesScreenState extends State<AllChallengesScreen> {
  int? selectedIndex;
  late List<GroupChallenges> allChallenges = [];
  FirebaseService _firebaseService = FirebaseService();
  @override
  void initState() {
    super.initState();
    // Call upload and download operations after a delay
    Future.delayed(Duration.zero, () async {
      //await _uploadChallengesToFirebase();
      await _downloadChallengesFromFirebase();
    });
  }

  // Function to upload challenges to Firebase
  // Future<void> _uploadChallengesToFirebase() async {
  //   await _firebaseService.uploadChallenges(allChallenges);
  // }

  // Function to download challenges from Firebase
  Future<void> _downloadChallengesFromFirebase() async {
    List<GroupChallenges> downloadedChallenges = await _firebaseService.downloadChallenges();

    setState(() {
      allChallenges = downloadedChallenges;
    });
  }
  String getFormattedToday() {
    return DateFormat('dd MMM').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Color.fromRGBO(247, 165, 237, 0.5),
        title: Container(
          padding: EdgeInsets.all(20.0),
          child: const Text(
            'All Challenges',
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: allChallenges.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      // Toggle selected index
                      selectedIndex = selectedIndex == index ? null : index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        SizedBox(height: 25,),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 201, 255, 1.0),
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
                                            allChallenges[index].title,
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              // Toggle checked status
                                              allChallenges[index].finished = !allChallenges[index].finished;

                                            });
                                          },
                                          child: allChallenges[index].finished
                                              ? const Icon(Icons.check_circle_outline_rounded, color: Colors.green)
                                              : const Icon(Icons.radio_button_unchecked_rounded, color: Colors.redAccent),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (selectedIndex == index)

                                Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("From ${DateFormat('dd MMM').format(allChallenges[index].challenges.first.startDate)} To ${DateFormat('dd MMM').format(allChallenges[index].challenges.last.endDate)}",style:TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                                        IconButton(
                                          icon: Icon(Icons.arrow_forward),
                                          onPressed: () {
                                            // Navigate to the detailed challenges page with the id
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ChallengesScreen(
                                                  groupChallenges: allChallenges[index],
                                                ),
                                              ),
                                            );
                                          },
                                        ),],

                                    ),
                                      const SizedBox(height: 10.0),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: allChallenges[index].challenges
                                            .map(
                                              (line) => Padding(
                                            padding: EdgeInsets.only(bottom: 8.0),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  '•',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.normal,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(width: 8.0),
                                                Expanded(
                                                  child: Text(
                                                    textAlign: TextAlign.justify,
                                                    line.title,
                                                    style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.normal,
                                                      color: Colors.black87,

                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                            .toList(),
                                      ),
                                    ],
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
