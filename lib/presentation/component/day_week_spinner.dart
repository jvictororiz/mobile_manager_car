import 'package:flutter/material.dart';

class DayOfWeekSpinner extends StatefulWidget {
  final Function(int) onDaySelected;

  const DayOfWeekSpinner({super.key, required this.onDaySelected});

  @override
  _DayOfWeekSpinnerState createState() => _DayOfWeekSpinnerState();
}

class _DayOfWeekSpinnerState extends State<DayOfWeekSpinner> {
  int selectedDay = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(right: 16),
      child: DropdownButtonFormField<int>(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        value: selectedDay,
        borderRadius: BorderRadius.circular(4),
        onChanged: (newValue) {
          setState(() {
            selectedDay = newValue ?? selectedDay;
          });
          widget.onDaySelected.call(newValue ?? selectedDay);
        },
        items: <DropdownMenuItem<int>>[
          const DropdownMenuItem<int>(
            value: 1,
            child: Text("Segunda"),
          ),
          const DropdownMenuItem<int>(
            value: 2,
            child: Text("Terça"),
          ),
          const DropdownMenuItem<int>(
            value: 3,
            child: Text("Quarta"),
          ),
          const DropdownMenuItem<int>(
            value: 4,
            child: Text("Quinta"),
          ),
          const DropdownMenuItem<int>(
            value: 5,
            child: Text("Sexta"),
          ),
          const DropdownMenuItem<int>(
            value: 6,
            child: Text("Sábado"),
          ),
          const DropdownMenuItem<int>(
            value: 7,
            child: Text("Domingo"),
          ),
        ],
      ),
    );
  }
}
