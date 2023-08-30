import 'package:flutter/material.dart';
import 'package:mobile_manager_car/presentation/component/weekly_date_picker.dart';

class WeekComponent extends StatelessWidget {
  final Function(DateTime, DateTime)? onChangeInitFinal;
  final Function(int, int)? onChangeWeekYear;

  const WeekComponent({Key? key, this.onChangeWeekYear, this.onChangeInitFinal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WeeklyDatePicker(
      weekdayText: "Semana",
      daysInWeek: 7,
      enableWeeknumberText: false,
      weekdays: ["Seg", "Ter", "Qua", "Qui", "Sex", "Sab", "Dom"],
      selectedDay: DateTime.now(),
      onChangeWeekYear: onChangeWeekYear,
    );
  }
}
