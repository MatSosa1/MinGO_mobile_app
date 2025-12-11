import '../../domain/entities/tag.dart';

class TagModel extends Tag {
  TagModel({
    super.id,
    required super.tagName,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['tag_id'],
      tagName: json['tag_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tag_id': id,
      'tag_name': tagName,
    };
  }
}
