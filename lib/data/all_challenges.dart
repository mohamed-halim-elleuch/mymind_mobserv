import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
  final String title;
  final String content;
  bool checked;
  DateTime startDate;
  DateTime endDate;

  Challenge({
    required this.title,
    required this.content,
    required this.checked,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'checked': checked,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}

class GroupChallenges {
  final String id;
  final String title;
  final List<Challenge> challenges;
  bool finished;

  GroupChallenges({
    required this.id,
    required this.title,
    required this.challenges,
    required this.finished,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'challenges': challenges.map((challenge) => challenge.toMap()).toList(),
      'finished': finished,
    };
  }
}

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadChallenges(List<GroupChallenges> challenges) async {
    final batch = _firestore.batch();

    for (final challenge in challenges) {
      final challengeDoc = _firestore.collection('challenges').doc(challenge.id);
      batch.set(challengeDoc, challenge.toMap());
    }

    await batch.commit();
  }


  Future<List<GroupChallenges>> downloadChallenges() async {
    final querySnapshot = await _firestore.collection('challenges').get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final List<dynamic> challengeData = data['challenges'];

      final challenges = challengeData.map((challenge) {
        return Challenge(
          title: challenge['title'],
          content: challenge['content'],
          checked: challenge['checked'],
          startDate: (challenge['startDate'] as Timestamp).toDate(),
          endDate: (challenge['endDate'] as Timestamp).toDate(),
        );
      }).toList();

      return GroupChallenges(
        id: data['id'],
        title: data['title'],
        challenges: challenges,
        finished: data['finished'],
      );
    }).toList();
  }
}

// List<GroupChallenges> allChallenges = [
//   GroupChallenges(
//     id: "group1",
//     title:"Challenge 1",
//
//     challenges: [
//       Challenge(
//         checked: true,
//         title: "Digital Detox",
//         content:
//         "Spend a day away from screens, phones, and computers.\nEngage in offline activities like reading, nature walks, meditation, or quality time with loved ones without digital distractions.",
//         startDate: DateTime.now(),
//         endDate: DateTime.now().add(Duration(days: 1)),
//       ),
//       Challenge(
//         checked: false,
//         title: "Mindful Breathing",
//         content:
//         "Practice mindful breathing exercises to reduce stress.\nTake a few moments each day to focus on your breath and clear your mind.",
//         startDate: DateTime.now().add(Duration(days: 2)),
//         endDate: DateTime.now().add(Duration(days: 3)),
//       ),
//       Challenge(
//         checked: true,
//         title: "Daily Exercise",
//         content:
//         "Include at least 30 minutes of exercise in your daily routine.\nChoose activities you enjoy, such as walking, jogging, or cycling.",
//         startDate: DateTime.now().add(Duration(days: 4)),
//         endDate: DateTime.now().add(Duration(days: 5)),
//       ),
//     ],
//     finished:true,
//   ),
//   GroupChallenges(
//     id: "group2",
//     title:"Challenge 2",
//     challenges: [
//       Challenge(
//         checked: false,
//         title: "Healthy Eating",
//         content:
//         "Focus on eating nutritious and balanced meals.\nIncorporate more fruits, vegetables, and whole grains into your diet.",
//         startDate: DateTime.now().add(Duration(days: 2)),
//         endDate: DateTime.now().add(Duration(days: 3)),
//       ),
//       Challenge(
//         checked: false,
//         title: "Reading Challenge",
//         content:
//         "Read a book or dedicate time to reading each day.\nExplore different genres and expand your knowledge.",
//         startDate: DateTime.now().add(Duration(days: 8)),
//         endDate: DateTime.now().add(Duration(days: 9)),
//       ),
//       Challenge(
//         checked: true,
//         title: "Random Acts of Kindness",
//         content:
//         "Perform random acts of kindness for others each day.\nSmall gestures can make a big difference in someone's day.",
//         startDate: DateTime.now().add(Duration(days: 10)),
//         endDate: DateTime.now().add(Duration(days: 11)),
//       ),
//     ],finished:true,
//   ),
//   GroupChallenges(
//     id: "group3",
//     title:"Challenge 3",
//     challenges: [
//       Challenge(
//         checked: true,
//         title: "Daily Exercise",
//         content:
//         "Include at least 30 minutes of exercise in your daily routine.\nChoose activities you enjoy, such as walking, jogging, or cycling.",
//         startDate: DateTime.now().add(Duration(days: 4)),
//         endDate: DateTime.now().add(Duration(days: 5)),
//       ),
//       Challenge(
//         checked: false,
//         title: "Reading Challenge",
//         content:
//         "Read a book or dedicate time to reading each day.\nExplore different genres and expand your knowledge.",
//         startDate: DateTime.now().add(Duration(days: 8)),
//         endDate: DateTime.now().add(Duration(days: 9)),
//       ),
//       Challenge(
//         checked: true,
//         title: "Random Acts of Kindness",
//         content:
//         "Perform random acts of kindness for others each day.\nSmall gestures can make a big difference in someone's day.",
//         startDate: DateTime.now().add(Duration(days: 10)),
//         endDate: DateTime.now().add(Duration(days: 11)),
//       ),
//     ],finished:true,
//   ),
//   GroupChallenges(
//     id: "group4",
//     title:"Challenge 4",
//     challenges: [
//       Challenge(
//         checked: false,
//         title: "Mindful Breathing",
//         content:
//         "Practice mindful breathing exercises to reduce stress.\nTake a few moments each day to focus on your breath and clear your mind.",
//         startDate: DateTime.now().add(Duration(days: 6)),
//         endDate: DateTime.now().add(Duration(days: 7)),
//       ),
//       Challenge(
//         checked: false,
//         title: "Reading Challenge",
//         content:
//         "Read a book or dedicate time to reading each day.\nExplore different genres and expand your knowledge.",
//         startDate: DateTime.now().add(Duration(days: 8)),
//         endDate: DateTime.now().add(Duration(days: 9)),
//       ),
//       Challenge(
//         checked: true,
//         title: "Random Acts of Kindness",
//         content:
//         "Perform random acts of kindness for others each day.\nSmall gestures can make a big difference in someone's day.",
//         startDate: DateTime.now().add(Duration(days: 10)),
//         endDate: DateTime.now().add(Duration(days: 11)),
//       ),
//     ],finished:true,
//   ),
//   GroupChallenges(
//     id: "group5",
//     title:"Challenge 5",
//     challenges: [
//       Challenge(
//         checked: true,
//         title: "Gratitude Journal",
//         content:
//         "Start a gratitude journal and write down three things you're grateful for each day.\nReflect on positive aspects of your life.",
//         startDate: DateTime.now().add(Duration(days: 8)),
//         endDate: DateTime.now().add(Duration(days: 9)),
//       ),
//       Challenge(
//         checked: false,
//         title: "Mindful Breathing",
//         content:
//         "Practice mindful breathing exercises to reduce stress.\nTake a few moments each day to focus on your breath and clear your mind.",
//         startDate: DateTime.now().add(Duration(days: 2)),
//         endDate: DateTime.now().add(Duration(days: 3)),
//       ),
//       Challenge(
//         checked: true,
//         title: "Daily Exercise",
//         content:
//         "Include at least 30 minutes of exercise in your daily routine.\nChoose activities you enjoy, such as walking, jogging, or cycling.",
//         startDate: DateTime.now().add(Duration(days: 4)),
//         endDate: DateTime.now().add(Duration(days: 5)),
//       ),
//     ],finished:true,
//   ),
//   GroupChallenges(
//     id: "group6",
//     title:"Challenge 6",
//     challenges: [
//       Challenge(
//         checked: false,
//         title: "Reading Challenge",
//         content:
//         "Read a book or dedicate time to reading each day.\nExplore different genres and expand your knowledge.",
//         startDate: DateTime.now().add(Duration(days: 10)),
//         endDate: DateTime.now().add(Duration(days: 11)),
//       ),
//       Challenge(
//         checked: false,
//         title: "Mindful Breathing",
//         content:
//         "Practice mindful breathing exercises to reduce stress.\nTake a few moments each day to focus on your breath and clear your mind.",
//         startDate: DateTime.now().add(Duration(days: 2)),
//         endDate: DateTime.now().add(Duration(days: 3)),
//       ),
//       Challenge(
//         checked: true,
//         title: "Daily Exercise",
//         content:
//         "Include at least 30 minutes of exercise in your daily routine.\nChoose activities you enjoy, such as walking, jogging, or cycling.",
//         startDate: DateTime.now().add(Duration(days: 4)),
//         endDate: DateTime.now().add(Duration(days: 5)),
//       ),
//     ],finished:false,
//   ),
//   GroupChallenges(
//     id: "group7",
//     title:"Challenge 7",
//     challenges: [
//       Challenge(
//         checked: true,
//         title: "Random Acts of Kindness",
//         content:
//         "Perform random acts of kindness for others each day.\nSmall gestures can make a big difference in someone's day.",
//         startDate: DateTime.now().add(Duration(days: 12)),
//         endDate: DateTime.now().add(Duration(days: 13)),
//       ),
//       Challenge(
//         checked: false,
//         title: "Mindful Breathing",
//         content:
//         "Practice mindful breathing exercises to reduce stress.\nTake a few moments each day to focus on your breath and clear your mind.",
//         startDate: DateTime.now().add(Duration(days: 2)),
//         endDate: DateTime.now().add(Duration(days: 3)),
//       ),
//       Challenge(
//         checked: true,
//         title: "Daily Exercise",
//         content:
//         "Include at least 30 minutes of exercise in your daily routine.\nChoose activities you enjoy, such as walking, jogging, or cycling.",
//         startDate: DateTime.now().add(Duration(days: 4)),
//         endDate: DateTime.now().add(Duration(days: 5)),
//       ),
//     ],finished:false,
//   ),
//
// ];
