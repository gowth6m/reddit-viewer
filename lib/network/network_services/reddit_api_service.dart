import 'package:chopper/chopper.dart';
import 'package:reddit_viewer/misc/globals.dart';

// required to find the generated file
part 'reddit_api_service.chopper.dart';

@ChopperApi(baseUrl: Globals.endpoint)
abstract class RedditApiService extends ChopperService {
  @Get(path: '/{subreddit}.json')
  Future<Response> getAllPosts(@Path() String subreddit);

  static RedditApiService create() {
    final client = ChopperClient(
      baseUrl: Globals.endpoint,
      services: [_$RedditApiService()],
      converter: const JsonConverter(),
    );
    return _$RedditApiService(client);
  }
}
