import 'package:date_picker/constant/app_constant.dart';
import 'package:date_picker/constant/palette.dart';
import 'package:date_picker/model/date_time_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WheelDatePicker extends StatefulWidget {
  WheelDatePicker(
      {this.locale = 'vi',
      this.minYear = 1009,
      this.maxYear = 3023,
      this.initDate});

  String locale;
  int minYear;
  int maxYear;
  DateTime initDate = DateTime.now();

  @override
  _WheelDatePickerState createState() => _WheelDatePickerState();
}

class _WheelDatePickerState extends State<WheelDatePicker> {
  final items = List<int>.generate(100, (i) => i);

  DateTime _now = DateTime.now();
  DateTime _dateSelected;
  DateTimeModel _modelSelected;

  List<DateTimeModel> _listDateModels = [];
  List<DateTimeModel> _listMonthModels = [];
  List<DateTimeModel> _listYearModels = [];

  @override
  void initState() {
    super.initState();
    _dateSelected = widget.initDate ?? DateTime.now();
    _listDateModels = _parseListDatesToModel();
    _listYearModels = _parseListYearsToModel();
    _listMonthModels = _parseListMonthsToModel();
    _modelSelected = _listYearModels.first;
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 200,
      child: Stack(
        children: [
          _buildMagnifier(),
          _buildListWheels(),
        ],
      ),
    );
  }

  Widget _buildMagnifier() {
    return IgnorePointer(
      child: Center(
        child: Container(
          height: 50,
          color: Palette.PRIMARY_COLOR,
        ),
      ),
    );
  }

  Widget _buildListWheels() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            _buildWheel(data: _listDateModels),
            _buildWheel(
                flex: 2,
                data: _listMonthModels,
                condition: _dateSelected.month,
                onChange: (index) {
                  _dateSelected = _dateSelected.copyWith(
                      month: _listMonthModels[index].index);
                }),
            _buildWheel(
                data: _listYearModels,
                condition: _dateSelected.year,
                onChange: (index) {
                  _dateSelected = _dateSelected.copyWith(
                      year: _listYearModels[index].index);
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildWheel(
      {int flex = 1,
      List<DateTimeModel> data,
      Function(int) onChange,
      int condition}) {
    return Expanded(
      flex: flex,
      child: ListWheelScrollView(
        physics: const FixedExtentScrollPhysics(),
        children: data.map((model) {
          return Text(
            model.time.toString(),
            style: TextStyle(
              color: (model.index == condition)
                  ? Palette.WHITE
                  : Palette.PRIMARY_COLOR,
            ),
          );
        }).toList(),
        useMagnifier: true,
        magnification: 1.5,
        itemExtent: 35.0,
        diameterRatio: 1.2,
        onSelectedItemChanged: (index) {
          setState(() {
            onChange(index);
          });
        },
      ),
    );
  }

  List<DateTimeModel> _parseListYearsToModel() {
    List<DateTimeModel> _listYearModels = [];
    for (int i = widget.maxYear; i >= widget.minYear; i--) {
      _listYearModels
          .add(DateTimeModel(i.toString(), i == _dateSelected.year, i));
    }

    return _listYearModels.toList();
  }

  List<DateTimeModel> _parseListDatesToModel() {
    List<DateTimeModel> _listDateModels = List<DateTimeModel>.generate(
      30,
      (date) => DateTimeModel(date.toString(), false, date),
    );

    return _listDateModels.reversed.toList();
  }

  List<DateTimeModel> _parseListMonthsToModel() {
    List<DateTimeModel> _listMonthModels = [];
    List<String> _listMonthsByLocale = [];

    switch (widget.locale) {
      case 'vi':
        _listMonthsByLocale = AppConstants.VIETNAM_MONTHS;
        break;
      case 'en':
        _listMonthsByLocale = AppConstants.ENGLISH_MONTHS;
        break;
      default:
        break;
    }
    for (int i = 0; i < _listMonthsByLocale.length; i++) {
      _listMonthModels.add(
        DateTimeModel(_listMonthsByLocale[i], i == _dateSelected.month, i + 1),
      );
    }
    return _listMonthModels;
  }
}

extension DateTimeExtension on DateTime {
  DateTime copyWith({int year, int month, int date}) {
    return DateTime(year ?? this.year, month ?? this.month, day ?? this.day);
  }
}
