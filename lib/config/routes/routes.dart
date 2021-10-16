import 'package:flutter/material.dart';
import 'package:snapwork_events_app/modules/events_list/screens/events_list_screen.dart';

class Routes {
  static const eventsList = '/';
  static const createEvents = '/login';
}

Map<String, WidgetBuilder> appRoutes = {
  Routes.eventsList: (context) => const EventsListScreen(),
  // Routes.createEvents: (context) => const CreateEventScreen()
};
