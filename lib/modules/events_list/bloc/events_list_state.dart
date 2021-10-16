part of 'events_list_bloc.dart';

abstract class EventsListState extends Equatable {
  final int? selectedYear;
  final Map<String, dynamic>? selectedMonth;

  const EventsListState({
    @required this.selectedYear,
    @required this.selectedMonth,
  });
}

class EventsLoading extends EventsListState {
  final int? currentYear;
  final Map<String, dynamic>? currentMonth;

  const EventsLoading({
    @required this.currentYear,
    @required this.currentMonth,
  }) : super(selectedYear: currentYear, selectedMonth: currentMonth);

  @override
  List<Object?> get props => [currentYear, currentMonth];
}

class EventsLoaded extends EventsListState {
  final int selectedYear;
  final Map<String, dynamic> selectedMonth;
  final List<Days> events;

  const EventsLoaded({
    required this.selectedYear,
    required this.selectedMonth,
    required this.events,
  }) : super(selectedYear: selectedYear, selectedMonth: selectedMonth);

  @override
  List<Object?> get props => [selectedYear, selectedMonth, events];
}
