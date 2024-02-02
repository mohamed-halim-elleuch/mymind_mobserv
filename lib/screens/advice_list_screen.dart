import 'package:flutter/material.dart';
import '../services/data_service.dart';

class AdviceListScreen extends StatefulWidget {
  const AdviceListScreen({super.key});

  @override
  AdviceListScreenState createState() => AdviceListScreenState();
}

class AdviceListScreenState extends State<AdviceListScreen> {
  final DataService dataService = DataService();
  late List<Map<String, dynamic>> adviceList;

  @override
  void initState() {
    super.initState();
    adviceList = [];
    fetchData();
  }

  Future<void> fetchData() async {
    List<Map<String, dynamic>> fetchedAdviceList = await dataService.fetchAdviceData();
    setState(() {
      adviceList = fetchedAdviceList;
    });
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Advice List"),
      ),
      body: adviceList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: adviceList.length,
              itemBuilder: (context, index) {
                var title = adviceList[index]['title'];
                var body = adviceList[index]['body'];

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