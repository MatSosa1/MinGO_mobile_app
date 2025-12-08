import '../../domain/entities/sign_synonym.dart';

class SignSynonymModel extends SignSynonym {
  SignSynonymModel({
    super.id,
    required super.synonymWord,
    required super.signId,
  });

  factory SignSynonymModel.fromJson(Map<String, dynamic> json) {
    return SignSynonymModel(
      id: json['id'],
      synonymWord: json['synonym_word'],
      signId: json['sign_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'synonym_word': synonymWord,
      'sign_id': signId,
    };
  }
}
