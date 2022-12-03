import 'package:json_annotation/json_annotation.dart';
import 'package:reddit_viewer/network/model/post_data.dart';

// this is necessary for the generated code to find your class
part 'network_post.g.dart';

@JsonSerializable()
class NetworkPostsList {
  @JsonKey(name: 'kind')
  String kind;

  @JsonKey(name: 'data')
  List<PostData>? data;

  NetworkPostsList(
    this.kind,
    this.data,
  );

  factory NetworkPostsList.fromJson(final Map<String, dynamic> json) {
    return _$NetworkPostsListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$NetworkPostsListToJson(this);
}
