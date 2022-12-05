import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_viewer/network/models/listing.dart';
import 'package:reddit_viewer/network/network_services/reddit_api_service.dart';

void main() {
  group('Reddit API integration check', () {
    test('Get reddit search', () async {
      final service = RedditApiService.create();
      final response = await service.getAllPosts('flutterdev');
      final items = Listing.fromJson(response.body);

      expect(items.data != null, true);
    });

    test('Get null reddit search', () async {
      final service = RedditApiService.create();
      final response = await service.getAllPosts('fluttertestingtofailcase');

      expect(response.body == null, true);
    });

    test('Get reddit search length check', () async {
      final service = RedditApiService.create();
      final response = await service.getAllPosts('flutterdev');
      final items = Listing.fromJson(response.body);

      expect(items.data!.dist == 27, true);
    });

    test('Get listing type check', () async {
      final service = RedditApiService.create();
      final response = await service.getAllPosts('flutterdev');
      final items = Listing.fromJson(response.body);

      expect(items.kind == "Listing", true);
    });

    test('Get t3 type check', () async {
      final service = RedditApiService.create();
      final response = await service.getAllPosts('flutterdev');
      final items = Listing.fromJson(response.body);
      final children = items.data!.children;

      expect(children!.first.kind == "t3", true);
    });

    test('Get t3 data check', () async {
      final service = RedditApiService.create();
      final response = await service.getAllPosts('flutterdev');
      final items = Listing.fromJson(response.body);
      final children = items.data!.children;

      expect(children!.first.data!.subreddit == "FlutterDev", true);
    });
  });
}
