import 'package:flutter/material.dart';
import 'package:mashghal_co/providers/reservationsProvider.dart';
import 'package:provider/provider.dart';

class DateTimeWidget extends StatefulWidget {
  final List<String> days;
  final List<String> hours;
  
  final Function callback;

  DateTimeWidget({this.days, this.hours, this.callback});

  @override
  _DateTimeWidgetState createState() => _DateTimeWidgetState();
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  //------------------------------variables-------------------------------------
  String _selectedTime = '';
  String _selectedDate = '';
  int selectedIndex = 0;
  //-------------------------------methods--------------------------------------
  void _selectTime(String selectedTime) {
    setState(() {
      _selectedTime = selectedTime;
    });
    widget.callback(_selectedDate.split(' ').first, _selectedTime);
    // print('index in DATETIMEWIDGET is ${widget.index}');
    // Provider.of<Reservations>(context).ordersId.first.day = _selectedDate.split(' ').first;
    // Provider.of<Reservations>(context).ordersId.first.hours = _selectedTime;
  }

  void _selectDate(String selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
      selectedIndex = widget.days.isEmpty?0:widget.days .indexOf(_selectedDate.split(' ').first);
    });
  }

  //----------------------------build-------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          height: 25.0,
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          width: MediaQuery.of(context).size.width * 0.33,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey[500],
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              items: List.generate(
                  (int.parse(widget.hours[selectedIndex].split(' ').last) -
                      int.parse(widget.hours[selectedIndex].split(' ').first) +
                      1), (index) {
                return DropdownMenuItem(
                  child: Text(
                      '${int.parse(widget.hours[selectedIndex].split(' ').first) + index}'),
                  value:
                      '${int.parse(widget.hours[selectedIndex].split(' ').first) + index}',
                );
              }),
              onChanged: _selectTime,
              isExpanded: false,
              hint: FittedBox(
                child: _selectedTime.isEmpty
                    ? FittedBox(
                        child: Text(
                          'اختر الوقت',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.0,
                            fontFamily: 'beINNormal',
                          ),
                        ),
                      )
                    : Text(
                        _selectedTime,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                          fontFamily: 'beINNormal',
                        ),
                      ),
              ),
              iconDisabledColor: Colors.grey,
              iconEnabledColor: Colors.grey,
            ),
          ),
        ),
        Container(
          height: 25.0,
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          width: MediaQuery.of(context).size.width * 0.33,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey[500],
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              items: List.generate(widget.days.length, (index) {
                selectedIndex = index;
                print('$index');
                return DropdownMenuItem(
                  child:
                      Text('${widget.days[index]} -- ${widget.hours[index]}'),
                  value: '${widget.days[index]} -- ${widget.hours[index]}',
                );
              }),
              onChanged: _selectDate,
              isExpanded: true,
              hint: _selectedDate.isEmpty
                  ? FittedBox(
                      child: Text(
                        'اخترالتاريخ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                          fontFamily: 'beINNormal',
                        ),
                      ),
                    )
                  : FittedBox(
                      child: Text(
                        _selectedDate,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                          fontFamily: 'beINNormal',
                        ),
                      ),
                    ),
              iconDisabledColor: Colors.grey,
              iconEnabledColor: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
  // showTimez(){
  //   . showTimePicker(context: null, initialTime: null,);
  // }
}
