import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/all_challenges.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';

class ChallengesScreen extends StatefulWidget {
  var groupChallenges;

  ChallengesScreen({required this.groupChallenges});


  @override
  _ChallengesScreenState createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  int? selectedIndex;
  late GroupChallenges groupChallenges = widget.groupChallenges;

  @override
  void initState() {
    super.initState();
    // groupChallenges = allChallenges.firstWhere(
    //       (group) => group.id == widget.groupId,
    //   orElse: () => GroupChallenges(id: "", challenges: [], finished: false, title: ''),
    // );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    showCustomDateRangePicker(
      context,
      dismissible: true,
      minimumDate: DateTime.now().subtract(const Duration(days: 30)),
      maximumDate: DateTime.now().add(const Duration(days: 30)),
      endDate: groupChallenges?.challenges.last.endDate,
      startDate: groupChallenges?.challenges[0].startDate,
      backgroundColor: Colors.white,
      primaryColor: Colors.green,
      onApplyClick: (start, end) {
        setState(() {

          groupChallenges?.challenges.last.endDate = end;
          groupChallenges?.challenges[0].startDate = start;
        });
      },
      onCancelClick: () {
        groupChallenges?.challenges.last.endDate=DateTime.now().add(const Duration(days: 5));
        groupChallenges?.challenges[0].startDate = DateTime.now();
      },
    );

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
            'My Challenge',
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0,20.0,0,0),
            child: ElevatedButton(
              onPressed: () => _selectDateRange(context),
              child: Text("Challenges duration : ${DateFormat('dd MMM').format(groupChallenges!.challenges.first.startDate)} - ${DateFormat('dd MMM').format(groupChallenges!.challenges.last.endDate)}",style:TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: groupChallenges!.challenges.length,
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
                                            groupChallenges!.challenges[index].title,
                                            style: const TextStyle(
                                              fontSize: 16.0,
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
                                              groupChallenges?.challenges[index].checked = !groupChallenges!.challenges[index].checked;
            
                                            });
                                          },
                                          child: groupChallenges!.challenges[index].checked
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
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: groupChallenges!.challenges[index].content
                                        .split('\n')
                                        .map(
                                          (line) => Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
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
                                                line,
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
