import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:reddit_viewer/network/model/listing.dart';
import 'package:reddit_viewer/network/network_services/api_service.dart';
import 'package:reddit_viewer/misc/globals.dart';
import 'package:reddit_viewer/misc/design.dart';
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
          backgroundColor: DesignColors.redditOrange,
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
                  // If response is unsuccessful, show error message widget
                  if (snapshot.data?.body == null) {
                    return const _InvalidSearch();
                  }

                  // If response is successful, create object from json & show results
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
                                    '${Globals.endpointPrefix}${posts.data?.children?[index].data?.permalink}',
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
          : const _InitialDisplay(),
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
          fontSize: 16,
        ),
      ),
      onChanged: (value) {
        debouncer.run(() {
          if (value != '') {
            // Removing spaces from search query for better search results
            value = value.replaceAll(' ', '');

            apiResponse = apiService.getAllPosts(value);
            setState(() {
              currentSearch = value;
              appbarTitle = value;
            });
          }
        });
      },
    );
  }
}

class _InitialDisplay extends StatelessWidget {
  const _InitialDisplay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}

class _InvalidSearch extends StatelessWidget {
  const _InvalidSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Invalid subreddit',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Try another subreddit',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          )
        ],
      ),
    );
  }
}
