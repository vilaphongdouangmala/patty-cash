import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:easy_localization/easy_localization.dart';

part 'locale_provider.g.dart';

/// Provider for managing the app's locale
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    // Default to English locale
    return const Locale('en');
  }

  /// Change the app locale
  void changeLocale(BuildContext context, String languageCode) {
    // Update the locale in EasyLocalization
    context.setLocale(Locale(languageCode));
    
    // Update the state
    state = Locale(languageCode);
  }
  
  /// Get the current locale code
  String get currentLocaleCode => state.languageCode;
  
  /// Check if the current locale is the given language code
  bool isCurrentLocale(String languageCode) => state.languageCode == languageCode;
}
