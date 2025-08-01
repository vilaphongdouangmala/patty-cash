import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:patty_cash/src/providers/locale_provider.dart';
import 'package:patty_cash/src/theme/app_theme.dart';

/// A widget that allows users to switch between supported languages
class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeNotifierProvider);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'language.select_language'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // English language option
              Expanded(
                child: _LanguageOption(
                  languageCode: 'en',
                  languageName: 'language.english'.tr(),
                  isSelected: currentLocale.languageCode == 'en',
                ),
              ),
              const SizedBox(width: 16),
              // Thai language option
              Expanded(
                child: _LanguageOption(
                  languageCode: 'th',
                  languageName: 'language.thai'.tr(),
                  isSelected: currentLocale.languageCode == 'th',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A selectable language option
class _LanguageOption extends ConsumerWidget {
  final String languageCode;
  final String languageName;
  final bool isSelected;

  const _LanguageOption({
    required this.languageCode,
    required this.languageName,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        // Change locale when tapped
        ref.read(localeNotifierProvider.notifier).changeLocale(context, languageCode);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.2) : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            languageName,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppTheme.primaryColor : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
