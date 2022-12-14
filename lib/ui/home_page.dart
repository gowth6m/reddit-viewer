import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reddit_viewer/misc/globals.dart';
import 'package:reddit_viewer/misc/design.dart';
import 'package:reddit_viewer/network/models/listing.dart';
import 'package:reddit_viewer/network/network_services/reddit_api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../misc/debouncer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _controller = ScrollController();
  final debouncer = Debouncer(milliseconds: 500);
  late String appbarTitle = 'Reddit Viewer';
  late RedditApiService redditApiService;
  late Future<Response> apiResponse;
  bool _searchBoolean = false;
  bool scrolled = false;
  String currentSearch = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScrollEvent);
    redditApiService = RedditApiService.create();
  }

  @override
  void dispose() {
    _controller.removeListener(_onScrollEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      bottom: true,
      left: true,
      top: true,
      right: true,
      maintainBottomViewPadding: true,
      minimum: EdgeInsets.zero,
      child: Scaffold(
        appBar: AppBar(
            leading: !_searchBoolean ? const _RedditIcon() : null,
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
                      controller: _controller,
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final title =
                                  posts.data?.children?[index].data?.title ??
                                      'No title';
                              final author =
                                  posts.data?.children?[index].data?.author ??
                                      'No author';
                              final tag = posts.data?.children?[index].data
                                      ?.link_flair_text ??
                                  'No tag';

                              final selfText =
                                  posts.data?.children?[index].data?.selftext;

                              return InkWell(
                                onTap: () async {
                                  return showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(title),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text('Author: $author'),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text('$selfText'),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith((states) {
                                                // If the button is pressed, return green, otherwise blue
                                                if (states.contains(
                                                    MaterialState.pressed)) {
                                                  return DesignColors
                                                      .redditOrange;
                                                }
                                                return DesignColors
                                                    .redditOrange;
                                              }),
                                            ),
                                            child: const Text('View'),
                                            onPressed: () async {
                                              await launchUrl(
                                                Uri.parse(
                                                  '${Globals.endpointPrefix}${posts.data?.children?[index].data?.permalink}',
                                                ),
                                                webOnlyWindowName: '_blank',
                                              );
                                            },
                                          ),
                                          TextButton(
                                            style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith((states) {
                                                // If the button is pressed, return green, otherwise blue
                                                if (states.contains(
                                                    MaterialState.pressed)) {
                                                  return Colors.white;
                                                }
                                                return Colors.white;
                                              }),
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith((states) {
                                                // If the button is pressed, return green, otherwise blue
                                                if (states.contains(
                                                    MaterialState.pressed)) {
                                                  return DesignColors
                                                      .redditOrange;
                                                }
                                                return DesignColors
                                                    .redditOrange;
                                              }),
                                            ),
                                            child: const Text('Close'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  // await launchUrl(
                                  //   Uri.parse(
                                  //     '${Globals.endpointPrefix}${posts.data?.children?[index].data?.permalink}',
                                  //   ),
                                  //   webOnlyWindowName: '_blank',
                                  // );
                                },
                                child: _RedditListItemWidget(
                                    title: title,
                                    theme: theme,
                                    author: author,
                                    tag: tag,
                                    selfText: selfText),
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
      ),
    );
  }

  /// Appbar subreddit search
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
      onSubmitted: (value) {
        _searchBoolean = false;
      },
      onChanged: (value) {
        debouncer.run(() {
          if (value != '') {
            // Removing spaces from search query for better search results
            value = value.replaceAll(' ', '');

            apiResponse = redditApiService.getAllPosts(value);
            setState(() {
              currentSearch = value;
              appbarTitle = 'r/$value';
            });
          }
        });
      },
    );
  }

  /// To remove the search bar selected when user scrolls down
  void _onScrollEvent() {
    _searchBoolean = false;
    setState(() {});
  }
}

class _RedditIcon extends StatelessWidget {
  const _RedditIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SvgPicture.asset(
        'assets/images/reddit_logo.svg',
        height: 20.0,
        width: 20.0,
        color: DesignColors.light,
        allowDrawingOutsideViewBox: false,
      ),
    );
  }
}

/// Widget to display each post in the list
class _RedditListItemWidget extends StatelessWidget {
  const _RedditListItemWidget({
    Key? key,
    required this.title,
    required this.theme,
    required this.author,
    required this.tag,
    required this.selfText,
  }) : super(key: key);

  final String title;
  final ThemeData theme;
  final String author;
  final String tag;
  final String? selfText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: theme.textTheme.headline6),
          subtitle: Text('author: $author'),
          trailing: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: DesignColors.redditOrange,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  DesignSpacing.small,
                  DesignSpacing.tiny,
                  DesignSpacing.small,
                  DesignSpacing.tiny,
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: DesignColors.light,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
        selfText != ''
            ? Padding(
                padding: const EdgeInsets.all(
                  DesignSpacing.medium,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selfText!,
                      maxLines: 4,
                      overflow: TextOverflow.fade,
                    ),
                    const Text('...',
                        style: TextStyle(
                          fontSize: 40.0,
                          color: DesignColors.grey,
                        )),
                  ],
                ),
              )
            : Container(),
        const Divider(),
      ],
    );
  }
}

/// Widget to display when there is no search query
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

/// Widget to display when search query is invalid
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
            'Couldn\'t find anything',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Try another search or check your internet connection',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
