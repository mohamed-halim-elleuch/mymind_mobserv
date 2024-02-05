import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Mood { Happy, Sad, Excited, Calm, Angry }

class Reflection {
  String id;
  Mood mood;
  DateTime date;
  String description;

  Reflection({
    required this.id,
    required this.mood,
    required this.date,
    required this.description,
  });
  Map<String, dynamic> toMap() {
    return {
      'mood': mood.index,
      'date': Timestamp.fromDate(date),
      'description': description,
    };
  }
}


class ReflectionPage extends StatefulWidget {
  @override
  _ReflectionPageState createState() => _ReflectionPageState();
}

class _ReflectionPageState extends State<ReflectionPage> {
  TextEditingController _descriptionController = TextEditingController();
  Map<DateTime, List<Reflection>> _reflectionsMap = {};
  int _expandedReflectionIndex = -1;
  //late Mood _selectedMood;
  Mood _selectedMood = Mood.Happy; // Default mood

  @override
  void initState() {
    super.initState();
    _loadSelectedMood();
    _loadReflections();// Initialize _selectedMood only once
  }
  Future<void> _loadSelectedMood() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMood = Mood.values[prefs.getInt('selectedMood') ?? 0];
    });
  }

  Future<void> _saveSelectedMood(Mood mood) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedMood', mood.index);
  }
  Future<void> _addReflection(Mood selectedMood) async {
    if (_descriptionController.text.isNotEmpty) {
      DateTime currentDate = DateTime.now();
      DateTime dateWithoutTime = DateTime(currentDate.year, currentDate.month, currentDate.day);

      Reflection newReflection = Reflection(
        id: '', // Set an initial empty ID, it will be updated after storing in Firestore
        mood: selectedMood,
        date: currentDate,
        description: _descriptionController.text,
      );

      DocumentReference<Map<String, dynamic>> documentReference =
      await FirebaseFirestore.instance.collection('reflections').add(newReflection.toMap());

      setState(() {
        newReflection.id = documentReference.id; // Update ID after storing in Firestore

        if (_reflectionsMap.containsKey(dateWithoutTime)) {
          _reflectionsMap[dateWithoutTime]!.add(newReflection);
        } else {
          _reflectionsMap[dateWithoutTime] = [newReflection];
        }

        _descriptionController.clear();
      });
    }
  }

  Future<void> _loadReflections() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('reflections').get();

    setState(() {
      _reflectionsMap = Map.fromEntries(querySnapshot.docs.map((doc) {
        DateTime date = (doc.data()!['date'] as Timestamp).toDate();
        Reflection reflection = Reflection(
          id: doc.id,
          mood: Mood.values[doc.data()!['mood']],
          date: date,
          description: doc.data()!['description'],
        );
        return MapEntry(DateTime(date.year, date.month, date.day), [reflection]);
      }));
    });
  }

  void _shareOnFacebook(Reflection reflection) {
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(reflection.date);
    String message =
        'Reflection added on $formattedDate: ${_getMoodString(reflection.mood)} - ${reflection.description}';
    Share.share(message);
  }

  Widget _getMoodWidget(Mood mood) {
    switch (mood) {
      case Mood.Happy:
        return Text('😄 Happy', style: TextStyle(color: Colors.green));
      case Mood.Sad:
        return Text('😢 Sad', style: TextStyle(color: Colors.blue));
      case Mood.Excited:
        return Text('🎉 Excited', style: TextStyle(color: Colors.orange));
      case Mood.Calm:
        return Text('😌 Calm', style: TextStyle(color: Colors.purple));
      case Mood.Angry:
        return Text('😡 Angry', style: TextStyle(color: Colors.red));
    }
  }

  String _getMoodString(Mood mood) {
    switch (mood) {
      case Mood.Happy:
        return '😄 Happy';
      case Mood.Sad:
        return '😢 Sad';
      case Mood.Excited:
        return '🎉 Excited';
      case Mood.Calm:
        return '😌 Calm';
      case Mood.Angry:
        return '😡 Angry';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        // Define your custom theme for ReflectionPage here
       // primarySwatch: Colors.white,
       // scaffoldBackgroundColor: Colors.blue,
        textTheme: const TextTheme(
          headline6: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black87),
          subtitle1: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black54),
          bodyText1: TextStyle(fontSize: 18.0, color: Colors.black87),
          bodyText2: TextStyle(fontSize: 14.0, color: Colors.black54),
        ),
      ),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Reflection'),
            backgroundColor: const Color.fromRGBO(
                173, 224, 225, 1.0),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _reflectionsMap.length,
                  itemBuilder: (context, index) {
                    DateTime date = _reflectionsMap.keys.elementAt(index);
                    List<Reflection> reflections = _reflectionsMap[date]!;

                    return Card(
                      margin: EdgeInsets.all(8.0),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              DateFormat('yyyy-MM-dd').format(date),
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                          ...reflections.map((reflection) {
                            return ExpansionTile(
                              title: _getMoodWidget(reflection.mood),
                              subtitle: Text(
                                DateFormat('yyyy-MM-dd HH:mm').format(reflection.date),
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              onExpansionChanged: (expanded) {
                                setState(() {
                                  _expandedReflectionIndex = expanded ? index : -1;
                                });
                              },
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8),
                                      Text(
                                        reflection.description,
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Added on: ${DateFormat('yyyy-MM-dd HH:mm').format(reflection.date)}',
                                        style: Theme.of(context).textTheme.bodyText2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    Mood moodInBottomSheet = _selectedMood; // Use a local variable

                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DropdownButton<Mood>(
                                value: moodInBottomSheet,
                                onChanged: (Mood? value) {
                                  if (value != null) {
                                    setState(() {
                                      moodInBottomSheet = value;
                                      _selectedMood = moodInBottomSheet;
                                    });
                                  }
                                },
                                items: Mood.values.map<DropdownMenuItem<Mood>>((Mood mood) {
                                  return DropdownMenuItem<Mood>(
                                    value: mood,
                                    child: Text(
                                      _getMoodString(mood),
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  hintText: 'Why are you feeling "${_getMoodString(moodInBottomSheet)}"?',
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 18.0),
                              ),
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedMood = moodInBottomSheet;
                                  });
                                  _saveSelectedMood(moodInBottomSheet);
                                  _addReflection(_selectedMood);
                                  Navigator.pop(context); // Close the bottom sheet
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                child: Text('Add New Reflection'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
              child: Icon(Icons.add),
          ),
          ),
    );
    }
}