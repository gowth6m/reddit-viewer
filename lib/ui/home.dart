import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:reddit_viewer/network/network_services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ApiService apiService;
  late Future<Response> apiResponse;

  @override
  void initState() {
    super.initState();
    apiService = ApiService.create();
    apiResponse = apiService.getAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<Response>(
        future: apiResponse,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print(snapshot.data?.body);
            return Text(snapshot.data.toString());
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
