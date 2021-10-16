import 'package:flutter/material.dart';
import 'package:snapwork_events_app/app_constants.dart';
import 'package:snapwork_events_app/config/themes/theme_config.dart';

class YearsList extends StatelessWidget {
  final int selectedYear;

  const YearsList({Key? key, required this.selectedYear}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "Years",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const Divider(),
        Expanded(child: _Years(selectedYear: selectedYear)),
      ],
    );
  }
}

class _Years extends StatefulWidget {
  final int selectedYear;
  const _Years({Key? key, required this.selectedYear}) : super(key: key);

  @override
  __YearsState createState() => __YearsState();
}

class __YearsState extends State<_Years> {
  late final List<int> _years;

  @override
  void initState() {
    _years = [
      for (var i = AppConstants.yearsRange["start_year"]!;
          i <= AppConstants.yearsRange["end_year"]!;
          i += 1)
        i
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _years.length,
      separatorBuilder: (context, index) => Divider(
        color: Colors.black,
      ),
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).pop({'selected_year': _years[index]});
          },
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s),
            child: Text(
              _years[index].toString(),
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: _years[index] == widget.selectedYear
                      ? Theme.of(context).primaryColor
                      : null),
            ),
          ),
        );
      },
    );
  }
}
