import 'package:flutter/material.dart';
import '../../domain/entities/sign.dart';
import '../../domain/repositories/sign_repository.dart';
import '../pages/dynamic_content_page.dart';
import '../strategies/content_strategy.dart';

class ContentPageFactory {
  final SignRepository repository;

  ContentPageFactory(this.repository);

  Widget createPage(SignSection section) {
    final strategy = SectionContentStrategy(repository, section);

    return DynamicContentPage(strategy: strategy);
  }
}