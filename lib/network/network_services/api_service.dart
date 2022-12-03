import 'package:chopper/chopper.dart';

// this is necessary for the generated code to find your class
part 'api_service.chopper.dart';

@ChopperApi(baseUrl:'https://www.reddit.com/r/FlutterDev.json')
abstract class ApiService extends ChopperService {

  @Get()
  Future<Response> getAllPosts();


  static ApiService create() {
    final client = ChopperClient(
      baseUrl: 'https://www.reddit.com/r/FlutterDev.json',
      services: [_$ApiService()],
      converter: JsonConverter(),
    );
    return _$ApiService(client);
  }
}
