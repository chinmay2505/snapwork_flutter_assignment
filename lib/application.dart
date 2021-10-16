import 'dart:io';

import 'package:flutter/material.dart';

import 'package:snapwork_events_app/utils/services/local_storage_service.dart';

class Application {
  /// To assign and hold the instance of singleton class LocalStorageService
  static LocalStorageService? storageService;

  /// Detect the target platform
  static TargetPlatform platform =
      Platform.isIOS ? TargetPlatform.iOS : TargetPlatform.android;
}
