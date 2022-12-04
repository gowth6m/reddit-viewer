import 'package:chopper/chopper.dart';
import 'package:reddit_viewer/misc/globals.dart';

// this is necessary for the generated code to find your class
part 'api_service.chopper.dart';

@ChopperApi(baseUrl: Globals.endpoint)
abstract class ApiService extends ChopperService {
  @Get(path: '/{subreddit}.json')
  Future<Response> getAllPosts(@Path() String subreddit);

  static ApiService create() {
    final client = ChopperClient(
      baseUrl: Globals.endpoint,
      services: [_$ApiService()],
      converter: const JsonConverter(),
    );
    return _$ApiService(client);
  }
}
