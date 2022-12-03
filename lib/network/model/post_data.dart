import 'package:json_annotation/json_annotation.dart';
import 'package:reddit_viewer/network/model/post.dart';

part 'post_data.g.dart';

@JsonSerializable()
class PostData {
  PostData({
    this.children,
  });

  List<Post>? children;

  factory PostData.fromJson(Map<String, dynamic> json) =>
      _$PostDataFromJson(json);

  Map<String, dynamic> toJson() => _$PostDataToJson(this);
}
