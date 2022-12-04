import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:reddit_viewer/network/model/listing.dart';
import 'package:reddit_viewer/network/network_services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ApiService apiService;
  late Future<Response> apiResponse;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    apiService = ApiService.create();
    apiResponse = apiService.getAllPosts('LeagueOfLegends');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                SliverToBoxAdapter(
                  child: Container(
                    height: 100,
                    color: Color.fromARGB(255, 139, 139, 139),
                    child: Center(
                      child: TextField(
                        controller: _controller,
                        onChanged: (String value) async {
                          if (value != '13') {
                            return;
                          }

                          // await showDialog<void>(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return AlertDialog(
                          //       title: const Text('That is correct!'),
                          //       content: const Text('13 is the right answer.'),
                          //       actions: <Widget>[
                          //         TextButton(
                          //           onPressed: () {
                          //             Navigator.pop(context);
                          //           },
                          //           child: const Text('OK'),
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // );
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter /r/FlutterDev',
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return InkWell(
                        onTap: () async {
                          print(
                            '${posts.data?.children?[index].data?.permalink}',
                          );

                          await launchUrl(
                            Uri.parse(
                              'https://www.reddit.com${posts.data?.children?[index].data?.permalink}',
                            ),
                            webOnlyWindowName: '_blank',
                          );
                        },
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                posts.data?.children?[index].data?.title ??
                                    'No title',
                              ),
                              subtitle: Text(
                                'author: ${posts.data?.children?[index].data?.author}',
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
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
