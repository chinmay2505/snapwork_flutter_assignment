import 'dart:async' show Stream;

import 'package:bloc/bloc.dart';

import 'package:snapwork_events_app/config/themes/light_theme.dart';
import 'package:snapwork_events_app/config/themes/dark_theme.dart';
import './bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: lightThemeConfig));

  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is ThemeChanged) {
      yield ThemeState(
        themeData: event.isDarkMode ? darkThemeConfig : lightThemeConfig,
      );
    }
  }
}
