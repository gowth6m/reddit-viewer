import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:reddit_viewer/network/model/listing.dart';
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

            final Listing posts = Listing.fromJson(snapshot.data?.body);

            return CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final String title =
                          posts.data?.children?[index].data?.title ??
                              'No title';

                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              posts.data?.children?[index].data?.title ??
                                  'No title',
                            ),
                          ),
                          // Text(
                          //   posts.data?.children?[index].data?.selftext ??
                          //       'No selfText',
                          // ),
                          Text(
                            posts.data?.children?[index].data?.author ??
                                'No author',
                          ),
                          const Divider(),
                        ],
                      );
                    },
                    childCount: posts.data?.children?.length ?? 0,
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
