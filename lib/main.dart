import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snapwork_events_app/application.dart';
import 'package:snapwork_events_app/app_bloc_observer.dart';
import 'package:snapwork_events_app/utils/services/local_storage_service.dart';
import 'package:snapwork_events_app/app_component.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Create the instances of the singleton classes
  Application.storageService = await LocalStorageService.getInstance();

  /// Observe the behavior of [Bloc]
  Bloc.observer = AppBlocObserver();

  runApp(AppComponent());
}
