part of 'events_list_bloc.dart';

abstract class EventsListEvent extends Equatable {
  /// Passing class fields in a list to the Equatable super class
  const EventsListEvent([List props = const []]) : super();
}

/// Event to fetch the list of events
class FetchEvents extends EventsListEvent {
  final int year;
  final int month;

  const FetchEvents({required this.year, required this.month});

  @override
  List<Object> get props => [year, month];
}
