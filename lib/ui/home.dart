import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:reddit_viewer/network/model/listing.dart';
import 'package:reddit_viewer/network/network_services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

import 'debouncer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String appbarTitle = 'Reddit Viewer';
  late ApiService apiService;
  late Future<Response> apiResponse;
  final debouncer = Debouncer(milliseconds: 500);
  bool _searchBoolean = false;
  String currentSearch = '';

  @override
  void initState() {
    super.initState();
    apiService = ApiService.create();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: !_searchBoolean ? Text(appbarTitle) : _searchTextField(),
          actions: !_searchBoolean
              ? [
                  IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _searchBoolean = true;
                        });
                      })
                ]
              : [
                  IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchBoolean = false;
                        });
                      })
                ]),
      body: currentSearch != ''
          ? FutureBuilder<Response>(
              future: apiResponse,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // print(snapshot.data?.body);

                  if (snapshot.data == null) {
                    return const Center(
                      child: Text('Error'),
                    );
                  }
                  final Listing posts = Listing.fromJson(snapshot.data?.body);

                  return CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return InkWell(
                              onTap: () async {
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
                                      posts.data?.children?[index].data
                                              ?.title ??
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
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Search for a subreddit',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Example: FlutterDev',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  )
                ],
              ),
            ),
    );
  }

  Widget _searchTextField() {
    return TextField(
      autofocus: true,
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintText: 'Search',
        hintStyle: TextStyle(
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
      onChanged: (value) {
        debouncer.run(() {
          if (value != '') {
            // Removing spaces from search query for better search results
            value = value.replaceAll(' ', '');
            try {
              setState(() {
                currentSearch = value;
                apiResponse = apiService.getAllPosts(currentSearch);
                print('API RESPONSE = $apiResponse');
              });
            } catch (e) {
              print(e);
            }
            // apiResponse = apiService.getAllPosts(value);
            // setState(() {
            //   currentSearch = value;
            //   appbarTitle = value;
            // });
          }
        });
      },
    );
  }
}
