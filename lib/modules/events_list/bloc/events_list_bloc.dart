import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:snapwork_events_app/app_constants.dart';
import 'package:snapwork_events_app/application.dart';
import 'package:snapwork_events_app/shared/models/events_model.dart';

part 'events_list_event.dart';
part 'events_list_state.dart';

class EventsListBloc extends Bloc<EventsListEvent, EventsListState> {
  EventsListBloc()
      : super(
          EventsLoading(
            currentYear: DateTime.now().year,
            currentMonth: AppConstants.months[DateTime.now().month - 1],
          ),
        );

  @override
  Stream<EventsListState> mapEventToState(EventsListEvent event) async* {
    if (event is FetchEvents) {
      yield* _mapFetchEventsToState(event);
    }
  }

  Stream<EventsListState> _mapFetchEventsToState(FetchEvents event) async* {
    EventsLoading(
      currentYear: event.year,
      currentMonth: AppConstants.months[event.month - 1],
    );

    List<int> _allDays = _daysInMonth(event.year, event.month);
    Map<String, dynamic> _storedEvents = Application.storageService!.eventsList;
    List<Days> _days = [];

    _allDays.forEach((element) {
      Map<String, dynamic> _events = {
        "day": element,
        "time": "",
        "title": "",
        "description": ""
      };

      _days.add(Days.fromJson(_events));
    });

    if ((_storedEvents["years"] as List).isNotEmpty) {
      Events _eventsModel = Events.fromJson(_storedEvents);
      int _yearIndex = _eventsModel.years
          .indexWhere((element) => element.year == event.year);

      if (_yearIndex != -1) {
        int _monthIndex = _eventsModel.years[_yearIndex].months
            .indexWhere((element) => element.month == event.month);

        if (_monthIndex != -1) {
          _eventsModel.years[_yearIndex].months[_monthIndex].days
              .forEach((element) {
            _days[element.day].title = element.title;
            _days[element.day].time = element.time;
            _days[element.day].description = element.description;
          });
        }
      }
    }

    yield EventsLoaded(
      selectedYear: event.year,
      selectedMonth: AppConstants.months[event.month - 1],
      events: _days,
    );
  }

  // This returns the list of date in a given month
  List<int> _daysInMonth(int year, int month) {
    DateTime date = DateTime(year, month);
    DateTime firstDayThisMonth = DateTime(date.year, date.month, date.day);
    DateTime firstDayNextMonth = DateTime(firstDayThisMonth.year,
        firstDayThisMonth.month + 1, firstDayThisMonth.day);
    int totalDays = firstDayNextMonth.difference(firstDayThisMonth).inDays;

    return List<int>.generate(totalDays, (i) => i + 1);
  }
}
