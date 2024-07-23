import 'package:rideme_mobile/features/localization/domain/repository/localization_repo.dart';

class GetCurrentLocale {
  final LocalizationRepository repository;

  GetCurrentLocale({required this.repository});

  String call() {
    return repository.getCurrentLocale();
  }
}
