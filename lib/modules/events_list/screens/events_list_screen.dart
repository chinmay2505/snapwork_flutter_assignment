import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snapwork_events_app/config/themes/bloc/bloc.dart';
import 'package:snapwork_events_app/config/themes/theme_config.dart';
import 'package:snapwork_events_app/modules/events_list/bloc/events_list_bloc.dart';
import 'package:snapwork_events_app/utils/ui_utils.dart';
import 'package:snapwork_events_app/widgets/app_buttons.dart';

class EventsListScreen extends StatelessWidget {
  const EventsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SetAppScreenConfiguration.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>.value(
          value: BlocProvider.of<ThemeBloc>(context),
        ),
        BlocProvider<EventsListBloc>(
          create: (BuildContext context) => EventsListBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) => Scaffold(
          appBar: AppBar(title: Text("Events")),
          body: EventsList(themeState: themeState),
        ),
      ),
    );
  }
}

class EventsList extends StatefulWidget {
  final ThemeState themeState;

  const EventsList({Key? key, required this.themeState}) : super(key: key);

  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  @override
  void initState() {
    super.initState();

    /// Add event in Bloc [EventsListBloc] -> [FetchEvents]
    BlocProvider.of<EventsListBloc>(context).add(
        FetchEvents(year: DateTime.now().year, month: DateTime.now().month));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            BlocBuilder<EventsListBloc, EventsListState>(
              buildWhen: (previousState, currentState) =>
                  previousState.selectedYear != currentState.selectedYear ||
                  previousState.selectedMonth!["value"] !=
                      currentState.selectedMonth!["value"],
              builder: _buildTopButtons,
            ),
            const AppSizedBoxSpacing(heightSpacing: AppSpacing.xs),
            BlocBuilder<EventsListBloc, EventsListState>(
              builder: (context, state) {
                return (state is EventsLoading)
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container();
              },
            ),
            Expanded(
              child: BlocBuilder<EventsListBloc, EventsListState>(
                buildWhen: (previousState, currentState) =>
                    currentState is EventsLoaded,
                builder: _buildEventsList,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopButtons(BuildContext context, EventsListState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
      child: Row(
        children: <Widget>[
          AppElevatedButton(
            minWidth: 100.0,
            themeState: widget.themeState,
            message: state.selectedYear.toString(),
            onPressed: () {},
          ),
          Spacer(),
          AppElevatedButton(
            minWidth: 100.0,
            themeState: widget.themeState,
            message: state.selectedMonth!["name"],
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(BuildContext context, EventsListState state) {
    Widget _eventsWidget = Container();

    if (state is EventsLoaded) {
      _eventsWidget = LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.m, 0.0, AppSpacing.s, 0.0),
              child: ListView.separated(
                itemCount: state.events.length,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return IntrinsicHeight(
                    child: Row(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              state.events[index].day.toString(),
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            Text(
                              state.selectedMonth["name"],
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.xs),
                          child: VerticalDivider(thickness: 2.0),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
    }

    return _eventsWidget;
  }
}
