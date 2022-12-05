// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reddit_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$RedditApiService extends RedditApiService {
  _$RedditApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = RedditApiService;

  @override
  Future<Response<dynamic>> getAllPosts(String subreddit) {
    final String $url = 'https://www.reddit.com/r/${subreddit}.json';
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
