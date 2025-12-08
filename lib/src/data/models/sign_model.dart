import 'package:mingo/src/domain/entities/sign.dart';

class SignModel extends Sign {
  SignModel({
    super.id,
    required super.signTitle,
    required super.signVideoUrl,
    super.signImageUrl,
    required super.signSection,
    required super.tagId,
  });

  factory SignModel.fromJson(Map<String, dynamic> json) {
    return SignModel(
      id: json['id'],
      signTitle: json['sign_title'],
      signVideoUrl: json['sign_video_url'],
      signImageUrl: json['sign_image_url'],
      signSection: SignSection.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['sign_section'] as String).toLowerCase(),
      ),
      tagId: json['tag_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sign_title': signTitle,
      'sign_video_url': signVideoUrl,
      'sign_image_url': signImageUrl,
      'sign_section': signSection.name,
      'tag_id': tagId,
    };
  }
}
