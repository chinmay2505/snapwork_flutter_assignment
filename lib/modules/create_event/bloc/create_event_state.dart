part of 'create_event_bloc.dart';

abstract class CreateEventState extends Equatable {
  const CreateEventState();
  
  @override
  List<Object> get props => [];
}

class CreateEventInitial extends CreateEventState {}
