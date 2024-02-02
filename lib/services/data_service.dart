import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DataService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchAdviceData() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('advice').get();
      List<Map<String, dynamic>> adviceList = [];

      for (var document in querySnapshot.docs) {
        var adviceData = document.data() as Map<String, dynamic>;
        adviceList.add(adviceData);
      }

      return adviceList;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching advice data: $e');
      }
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchJokeData() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('jokes').get();
      List<Map<String, dynamic>> jokeList = [];

      for (var document in querySnapshot.docs) {
        var jokeData = document.data() as Map<String, dynamic>;
        jokeList.add(jokeData);
      }

      return jokeList;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching joke data: $e');
      }
      return [];
    }
  }

    Future<List<Map<String, dynamic>>> fetchPositiveVibesData() async {
    try { 
      QuerySnapshot querySnapshot = await firestore.collection('positive-vibes').get();
      List<Map<String, dynamic>> positiveVibesList = [];

      for (var document in querySnapshot.docs) {
        var positiveVibesData = document.data() as Map<String, dynamic>;
        positiveVibesList.add(positiveVibesData);
      }

      return positiveVibesList;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching positive vibes data: $e');
      }
      return [];
    }
  }

  // You can add more functions for other data here
}
