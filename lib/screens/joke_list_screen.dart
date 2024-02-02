import 'package:flutter/material.dart';
import '../services/data_service.dart';

class JokeListScreen extends StatefulWidget {
  const JokeListScreen({super.key});

  @override
  JokeListScreenState createState() => JokeListScreenState();
}

class JokeListScreenState extends State<JokeListScreen> {
  final DataService dataService = DataService();
  late List<Map<String, dynamic>> jokeList;

  @override
  void initState() {
    super.initState();
    jokeList = [];
    fetchData();
  }

  Future<void> fetchData() async {
    List<Map<String, dynamic>> fetchedJokeList = await dataService.fetchJokeData();
    setState(() {
      jokeList = fetchedJokeList;
    });
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Advice List"),
      ),
      body: jokeList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: jokeList.length,
              itemBuilder: (context, index) {
                var title = jokeList[index]['title'];
                var body = jokeList[index]['body'];

                return ListTile(
                  title: Text(title),
                  subtitle: Text(body),
                  // You can add more styling or widgets here
                );
              },
            ),
    );
  }
}
