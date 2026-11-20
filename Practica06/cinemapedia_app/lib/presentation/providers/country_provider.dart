import 'package:cinemapedia_app/config/constants/app_country.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedCountryProvider =
    NotifierProvider<SelectedCountryNotifier, AppCountry>(
      SelectedCountryNotifier.new,
    );

class SelectedCountryNotifier extends Notifier<AppCountry> {
  @override
  AppCountry build() => AppCountry.mexico;

  void select(AppCountry country) {
    state = country;
  }
}
