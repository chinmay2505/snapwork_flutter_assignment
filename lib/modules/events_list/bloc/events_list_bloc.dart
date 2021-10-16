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
    } else if (event is AddEvent) {
      yield* _mapAddEventToState(event);
    }
  }

  Stream<EventsListState> _mapFetchEventsToState(FetchEvents event) async* {
    yield EventsLoading(
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
            _days[element.day - 1].title = element.title;
            _days[element.day - 1].time = element.time;
            _days[element.day - 1].description = element.description;
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

  Stream<EventsListState> _mapAddEventToState(AddEvent event) async* {
    Map<String, dynamic> _storedEvents = Application.storageService!.eventsList;
    Events _events = Events.fromJson(_storedEvents);
    int _yearIndex = _events.years
        .indexWhere((element) => element.year == state.selectedYear);
    int _monthIndex = (_yearIndex != -1)
        ? _events.years[_yearIndex].months.indexWhere(
            (element) => element.month == state.selectedMonth!["value"])
        : -1;

    if (_yearIndex == -1) {
      Map<String, dynamic> _year = {
        'year': state.selectedYear,
        'months': [
          {
            'month': state.selectedMonth!["value"],
            'days': [_getEventMapObject(event)]
          }
        ]
      };

      _events.years.add(Years.fromJson(_year));
    } else if (_yearIndex != -1 && _monthIndex == -1) {
      Map<String, dynamic> _month = {
        'month': state.selectedMonth!["value"],
        'days': [_getEventMapObject(event)]
      };

      _events.years[_yearIndex].months.add(Months.fromJson(_month));
    } else {
      int _dayIndex = _events.years[_yearIndex].months[_monthIndex].days
          .indexWhere((element) => element.day == event.day);

      if (_dayIndex != -1) {
        Days _days =
            _events.years[_yearIndex].months[_monthIndex].days[_dayIndex];
        _days.title = event.title;
        _days.time = event.time;
        _days.description = event.description;
      } else {
        Map<String, dynamic> _day = _getEventMapObject(event);

        _events.years[_yearIndex].months[_monthIndex].days
            .add(Days.fromJson(_day));
      }
    }

    /// Store the events into the local storage
    Application.storageService!.eventsList = _events.toJson();

    /// Add event [FetchEvents]
    add(FetchEvents(
      year: state.selectedYear!,
      month: state.selectedMonth!["value"],
    ));
  }

  /// return the Map object of a event of a day
  Map<String, dynamic> _getEventMapObject(AddEvent event) {
    Map<String, dynamic> _day = {
      "day": event.day,
      "title": event.title,
      "time": event.time,
      "description": event.description
    };

    return _day;
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
