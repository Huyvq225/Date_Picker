import 'package:date_picker/constant/app_constant.dart';
import 'package:date_picker/constant/palette.dart';
import 'package:date_picker/model/date_time_model.dart';
import 'package:flutter/cupertino.dart';

class WheelDatePicker extends StatefulWidget {

  WheelDatePicker({this.locale = 'vi', this.minYear = 1009, this.maxYear = 3000});

  String locale;
  int minYear;
  int maxYear;

  @override
  _WheelDatePickerState createState() => _WheelDatePickerState();
}

class _WheelDatePickerState extends State<WheelDatePicker> {
  final items = List<int>.generate(100, (i) => i);

  List<DateTimeModel> _listDateModels = [];
  List<DateTimeModel> _listMonthModels = [];
  List<DateTimeModel> _listYearModels = [];

  @override
  void initState() {
    super.initState();
    _listDateModels = _parseListDatesToModel();
    _listYearModels = _parseListYearsToModel();
    _listMonthModels = _parseListMonthsToModel();
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return Container(
      height: 200,
      child: Stack(
        children: [
          // _buildMagnifier(),
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
            _buildWheel(flex: 2,data: _listMonthModels),
            _buildWheel(data: _listYearModels),
          ],
        ),
      ),
    );
  }

  Widget _buildWheel({int flex = 1, List<DateTimeModel> data}) {
    return Expanded(
      flex: flex,
      child: ListWheelScrollView(
        physics: const FixedExtentScrollPhysics(),
        children: data.map((model) {
          return Text(
            model.time.toString(),
            style: TextStyle(color: Palette.PRIMARY_COLOR),
          );
        }).toList(),
        useMagnifier: true,
        magnification: 1.5,
        itemExtent: 35.0,
        diameterRatio: 1.2,
        onSelectedItemChanged: (index) {},
      ),
    );
  }

  List<DateTimeModel> _parseListYearsToModel() {
    // List<DateTimeModel> = _getListMonth(year: _yearSelected);
    List<DateTimeModel> _listYearModels = List<DateTimeModel>.generate(
      (widget.maxYear - widget.minYear),
          (year) => DateTimeModel(year.toString(),
          false, year),
    );

    return _listYearModels.reversed.toList();
  }

  List<DateTimeModel> _parseListDatesToModel() {
    List<DateTimeModel> _listDateModels = List<DateTimeModel>.generate(
      30,
          (date) => DateTimeModel(date.toString(),
          false, date),
    );

    return _listDateModels.reversed.toList();
  }

  // List<DatePickerModel> _getListMonth({int year}) {
  //   _listDate = _getListDate();
  //   final int _monthNow = DateTime.now().month;
  //   final int _yearNow = DateTime.now().year;
  //   final List<DatePickerModel> _listMonthByLocal = _getFullMonth();
  //   if (year < _yearNow) {
  //     for (int i = 0; i < _listMonthByLocal.length; i++) {
  //       if (i == _monthSelected - 1) {
  //         _listMonthByLocal[i].selected = true;
  //       }
  //     }
  //     return _listMonthByLocal;
  //   } else if (year == _yearNow) {
  //     final List<DatePickerModel> _listMonthOfCurrentYear = [];
  //     for (int i = 0; i < _listMonthByLocal.length; i++) {
  //       if (i <= _monthNow - 1) {
  //         if (i == _monthSelected - 1) {
  //           _listMonthByLocal[i].selected = true;
  //         }
  //         _listMonthOfCurrentYear.add(_listMonthByLocal[i]);
  //       }
  //     }
  //     return _listMonthOfCurrentYear;
  //   }
  //   return [];
  // }

  // List<DatePickerModel> _getListDate() {
  //   final int _monthNow = DateTime.now().month;
  //   final int _dateNow = DateTime.now().day;
  //   final int _yearNow = DateTime.now().year;
  //   final List<DatePickerModel> _listDateModel = [];
  //   bool _isSelected = false;
  //   final int _quantity = DateTime(_yearSelected, _monthSelected + 1, 0).day;
  //   if (_monthNow == _monthSelected && _yearNow == _yearSelected) {
  //     for (int i = 0; i < _dateNow; i++) {
  //       if (i == _daySelected - 1) {
  //         _isSelected = true;
  //       } else if (_dateNow < _daySelected && i == _dateNow - 1) {
  //         _isSelected = true;
  //         _daySelected = _dateNow;
  //         dayScrollController.animateToItem(_dateNow,
  //             duration: const Duration(milliseconds: 200), curve: Curves.ease);
  //       } else {
  //         _isSelected = false;
  //       }
  //       _listDateModel.add(
  //         DatePickerModel('${i + 1}', _isSelected, i + 1),
  //       );
  //     }
  //   } else {
  //     for (int i = 0; i < _quantity; i++) {
  //       if (i == _daySelected - 1) {
  //         _isSelected = true;
  //       } else if (_quantity < _daySelected && i == _quantity - 1) {
  //         _isSelected = true;
  //         _daySelected = _quantity;
  //       } else {
  //         _isSelected = false;
  //       }
  //       _listDateModel.add(
  //         DatePickerModel('${i + 1}', _isSelected, i + 1),
  //       );
  //     }
  //   }
  //
  //   return _listDateModel;
  // }

  List<DateTimeModel> _parseListMonthsToModel() {
    List<DateTimeModel> _listMonthModels = [];
    List<String> _listMonthsByLocale = [];

    switch(widget.locale) {
      case 'vi':
        _listMonthsByLocale = AppConstants.VIETNAM_MONTHS;
        break;
      case 'en':
        _listMonthsByLocale = AppConstants.ENGLISH_MONTHS;
        break;
      default:
        break;
    }
    for(int i = 0; i < _listMonthsByLocale.length; i++) {
      _listMonthModels.add(DateTimeModel(_listMonthsByLocale[i], false, 1),);
    }
    return _listMonthModels;
  }
}
