import 'package:flutter/material.dart';
import 'task.dart';

class DetailPage extends StatefulWidget {
  Function del;
  Function upd;
  int ind;
  Task currenttask;
  String? restorationId;
  DetailPage(this.del, this.upd, this.ind,
      {required this.currenttask, this.restorationId});

  @override
  _DetailPageState createState() {
    return _DetailPageState();
  }
}

class _DetailPageState extends State<DetailPage> with RestorationMixin {
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
        widget.upd(
            widget.ind,
            "${_selectedDate.value.month}/${_selectedDate.value.day}/${_selectedDate.value.year}",
            "day");
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
        widget.upd(widget.ind, _time.format(context), "time");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currenttask.title),
      ),
      body: Column(children: <Widget>[
        Text('Task Title: ${widget.currenttask.title}'),
        const Text('Edit task title...'),
        TextField(onSubmitted: (String newTitle) {
          widget.upd(widget.ind, newTitle, "title");
        }),
        Text('Task Description: ${widget.currenttask.descrip}'),
        const Text('Edit task description...'),
        TextField(onSubmitted: (String newDescrip) {
          widget.upd(widget.ind, newDescrip, "desc");
        }),
        Text('Time: ${widget.currenttask.time}'),
        ElevatedButton(
          onPressed: () {
            _selectTime();
          },
          child: const Text('Edit task time'),
        ),
        Text('Day: ${widget.currenttask.day}'),
        OutlinedButton(
            onPressed: () {
              _restorableDatePickerRouteFuture.present();
            },
            child: const Text("Edit task day")),
      ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            widget.del(widget.ind);
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.delete_sharp)),
    );
  }
}
