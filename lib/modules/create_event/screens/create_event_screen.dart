import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapwork_events_app/config/themes/bloc/bloc.dart';
import 'package:snapwork_events_app/config/themes/theme_config.dart';
import 'package:snapwork_events_app/modules/events_list/bloc/events_list_bloc.dart';

import 'package:snapwork_events_app/shared/models/events_model.dart';
import 'package:snapwork_events_app/utils/ui_utils.dart';
import 'package:snapwork_events_app/widgets/app_buttons.dart';

class CreateEventScreen extends StatelessWidget {
  final Days day;
  final int selectedYear;
  final Map<String, dynamic> selectedMonth;

  const CreateEventScreen({
    Key? key,
    required this.day,
    required this.selectedYear,
    required this.selectedMonth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>.value(
          value: BlocProvider.of<ThemeBloc>(context),
        ),
        BlocProvider<EventsListBloc>.value(
          value: BlocProvider.of<EventsListBloc>(context),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) => Scaffold(
          appBar: AppBar(title: Text("Event Detail")),
          body: CreateEvent(
            themeState: themeState,
            day: day,
            selectedYear: selectedYear,
            selectedMonth: selectedMonth,
          ),
        ),
      ),
    );
  }
}

class CreateEvent extends StatefulWidget {
  final ThemeState themeState;
  final Days day;
  final int selectedYear;
  final Map<String, dynamic> selectedMonth;

  const CreateEvent({
    Key? key,
    required this.themeState,
    required this.day,
    required this.selectedYear,
    required this.selectedMonth,
  }) : super(key: key);

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  late final TextEditingController timeController;
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    timeController = TextEditingController()..text = widget.day.time!;
    titleController = TextEditingController()..text = widget.day.title;
    descriptionController = TextEditingController()
      ..text = widget.day.description!;
  }

  @override
  void dispose() {
    timeController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s),
              child: Column(
                children: [
                  _displayDateAndTime(),
                  const AppSizedBoxSpacing(heightSpacing: AppSpacing.s),
                  _displayTitle(),
                  const AppSizedBoxSpacing(heightSpacing: AppSpacing.s),
                  _displayDescription(),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 0,
          child: _displaySaveButton(),
        ),
      ],
    );
  }

  Widget _displayDateAndTime() {
    return Row(
      children: <Widget>[
        Expanded(flex: 3, child: Text("Date & Time")),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
            child: AppInputForm(
              placeholderText: "HH:MM",
              controller: timeController,
              themeState: widget.themeState,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
              '${widget.day.day}-${widget.selectedMonth["name"]}-${widget.selectedYear}'),
        ),
      ],
    );
  }

  Widget _displayTitle() {
    return Row(
      children: <Widget>[
        Expanded(flex: 3, child: Text("Title")),
        Expanded(
          flex: 7,
          child: Padding(
            padding: const EdgeInsets.only(left: AppSpacing.s),
            child: AppInputForm(
              placeholderText: "",
              controller: titleController,
              themeState: widget.themeState,
            ),
          ),
        ),
      ],
    );
  }

  Widget _displayDescription() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Description"),
        const AppSizedBoxSpacing(heightSpacing: AppSpacing.xs),
        AppInputMultiline(
          themeState: widget.themeState,
          placeholderText: "",
          controller: descriptionController,
        )
      ],
    );
  }

  Widget _displaySaveButton() {
    return SafeArea(
      child: AppElevatedButton(
        themeState: widget.themeState,
        minWidth: AppScreenConfig.screenWidth! * 0.9,
        message: "SAVE",
        onPressed: () {
          /// Add event in [EventsListBloc]
          BlocProvider.of<EventsListBloc>(context).add(
            AddEvent(
              day: widget.day.day,
              title: titleController.text,
              time: timeController.text,
              description: descriptionController.text,
            ),
          );

          Navigator.of(context).pop();
        },
      ),
    );
  }
}
