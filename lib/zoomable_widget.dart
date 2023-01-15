import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class ZoomableWidget extends StatefulWidget {
  const ZoomableWidget({super.key});

   
  @override
  _ZoomableWidgetState createState() => _ZoomableWidgetState();
}

class _ZoomableWidgetState extends State<ZoomableWidget> {
  double _scale = 1.0;
  late double _previousScale;
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: GestureDetector(
        onScaleStart: (ScaleStartDetails details) {
          _previousScale = _scale;
        },
        onScaleUpdate: (ScaleUpdateDetails details) {
          setState(() {
            _scale = _previousScale * details.scale;
          });
        },
        onScaleEnd: (ScaleEndDetails details) {
          _previousScale = 0;
        },
        child: Transform(
          transform: Matrix4.diagonal3(Vector3(_scale.clamp(1.0, 5.0),
              _scale.clamp(1.0, 5.0), _scale.clamp(1.0, 5.0))),
          alignment: FractionalOffset.center,
      child: SfCalendar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        view: CalendarView.month,
        firstDayOfWeek: 6,
       dataSource: MeetingDataSource(getAppointments()),

      ),
        ),
      ),
    );
  }
}
List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));

  meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: 'Board Meeting',
      recurrenceRule: 'FREQ=DAILY;COUNT=10',
      isAllDay: false));

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
