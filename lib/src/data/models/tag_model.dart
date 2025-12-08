import '../../domain/entities/tag.dart';

class TagModel extends Tag {
  TagModel({
    super.id,
    required super.tagName,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'],
      tagName: json['tag_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tag_name': tagName,
    };
  }
}
