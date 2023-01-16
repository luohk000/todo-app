import 'package:flutter/material.dart';
import 'task.dart';

class AddPage extends StatefulWidget {
  Function add;
  String? restorationId;
  AddPage(this.add, this.restorationId);
  @override
  _AddPageState createState() {
    return _AddPageState();
  }
}

class _AddPageState extends State<AddPage> with RestorationMixin {
  String newTitle = "";
  String newDescrip = "";
  String new_TIME = "";
  String new_DAY = "";

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2022),
          lastDate: DateTime(2024),
        );
      },
    );
  }

  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime(2023, 1, 16));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        new_DAY =
            "${_selectedDate.value.month}/${_selectedDate.value.day}/${_selectedDate.value.year}";
      });
    }
  }

  TimeOfDay _time = TimeOfDay(hour: 6, minute: 00);
  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        new_TIME = _time.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Task')),
      body: Column(
        children: <Widget>[
          const Text('Add title'),
          TextField(onSubmitted: (String t) {
            newTitle = t;
          }),
          const Text('Add description'),
          TextField(onSubmitted: (String d) {
            newDescrip = d;
          }),
          ElevatedButton(
            onPressed: () {
              _selectTime();
            },
            child: const Text('Add time'),
          ),
          OutlinedButton(
              onPressed: () {
                _restorableDatePickerRouteFuture.present();
              },
              child: const Text("Add day")),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            widget.add(new Task(newTitle, newDescrip, new_TIME, new_DAY));
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.add)),
    );
  }
}
