import 'package:mingo/src/domain/entities/sign.dart';

class SignModel extends Sign {
  SignModel({
    super.id,
    required super.signTitle,
    required super.description,
    required super.signVideoUrl,
    super.signImageUrl,
    required super.signSection,
    required super.tagId,
    super.synonyms,
  });

  factory SignModel.fromJson(Map<String, dynamic> json) {
    return SignModel(
      id: json['sign_id'],
      signTitle: json['sign_title'],
      description: json['sign_description'] ?? '',
      signVideoUrl: json['sign_video_url'],
      signImageUrl: json['sign_image_url'],
      signSection: SignSection.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['sign_section'] as String).toLowerCase(),
        orElse: () => SignSection.Principiante,
      ),
      tagId: json['tag_id'],
      synonyms: json['synonyms'] != null 
          ? List<String>.from(json['synonyms']) 
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sign_id': id,
      'sign_title': signTitle,
      'sign_description': description,
      'sign_video_url': signVideoUrl,
      'sign_image_url': signImageUrl,
      'sign_section': signSection.name,
      'tag_id': tagId,
      'synonyms': synonyms ?? [],
    };
  }
}