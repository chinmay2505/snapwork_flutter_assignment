import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_event_event.dart';
part 'create_event_state.dart';

class CreateEventBloc extends Bloc<CreateEventEvent, CreateEventState> {
  CreateEventBloc() : super(CreateEventInitial());

  @override
  Stream<CreateEventState> mapEventToState(CreateEventEvent event) async* {}
}
