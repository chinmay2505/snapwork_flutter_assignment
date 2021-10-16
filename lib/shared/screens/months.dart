import 'package:flutter/material.dart';
import 'package:snapwork_events_app/app_constants.dart';
import 'package:snapwork_events_app/config/themes/theme_config.dart';

class MonthsList extends StatelessWidget {
  final int selectedMonth;

  const MonthsList({Key? key, required this.selectedMonth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "Months",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const Divider(),
        Expanded(child: _Months(selectedMonth: selectedMonth)),
      ],
    );
  }
}

class _Months extends StatefulWidget {
  final int selectedMonth;
  const _Months({Key? key, required this.selectedMonth}) : super(key: key);

  @override
  __MonthsState createState() => __MonthsState();
}

class __MonthsState extends State<_Months> {
  late final List<Map<String, dynamic>> _months;

  @override
  void initState() {
    _months = AppConstants.months;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _months.length,
      separatorBuilder: (context, index) => Divider(
        color: Colors.black,
      ),
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            Navigator.of(context)
                .pop({'selected_month': _months[index]["value"]});
          },
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s),
            child: Text(
              _months[index]["name"],
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: _months[index]["value"] == widget.selectedMonth
                      ? Theme.of(context).primaryColor
                      : null),
            ),
          ),
        );
      },
    );
  }
}
