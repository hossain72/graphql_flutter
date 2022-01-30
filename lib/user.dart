// To parse this JSON data, do
//
//     final posts = postsFromJson(jsonString);

import 'dart:convert';

Posts postsFromJson(String str) => Posts.fromJson(json.decode(str));

String postsToJson(Posts data) => json.encode(data.toJson());

class Posts {
  Posts({
    this.posts,
  });

  PostsClass posts;

  factory Posts.fromJson(Map<String, dynamic> json) => Posts(
    posts: PostsClass.fromJson(json["posts"]),
  );

  Map<String, dynamic> toJson() => {
    "posts": posts.toJson(),
  };
}

class PostsClass {
  PostsClass({
    this.data,
  });

  List<Datum> data;

  factory PostsClass.fromJson(Map<String, dynamic> json) => PostsClass(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.title,
  });

  String id;
  String title;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}
