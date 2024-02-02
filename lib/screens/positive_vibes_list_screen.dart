import 'package:flutter/material.dart';
import '../services/data_service.dart';

class PositiveVibesListScreen extends StatefulWidget {
  const PositiveVibesListScreen({super.key});

  @override
  PositiveVibesListScreenState createState() => PositiveVibesListScreenState();
}

class PositiveVibesListScreenState extends State<PositiveVibesListScreen> {
  final DataService dataService = DataService();
  late List<Map<String, dynamic>> positiveVibesList;

  @override
  void initState() {
    super.initState();
    positiveVibesList = [];
    fetchData();
  }

  Future<void> fetchData() async {
    List<Map<String, dynamic>> fetchedPositiveVibesList = await dataService.fetchPositiveVibesData();
    setState(() {
      positiveVibesList = fetchedPositiveVibesList;
    });
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Positive Vibes List"),
      ),
      body: positiveVibesList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: positiveVibesList.length,
              itemBuilder: (context, index) {
                var title = positiveVibesList[index]['title'];
                var body = positiveVibesList[index]['body'];

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