import 'package:date_picker/calendar/wheel_picker.dart';
import 'package:date_picker/constant/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePickerCustom extends StatefulWidget {
  @override
  _DatePickerCustomState createState() => _DatePickerCustomState();
}

class _DatePickerCustomState extends State<DatePickerCustom> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Palette.PRIMARY_COLOR,
      title: Text('Date Picker'),
    );
  }

  Widget _buildBody() {
    return Center(child: WheelDatePicker(maxYear: DateTime.now().year,));
  }


}

