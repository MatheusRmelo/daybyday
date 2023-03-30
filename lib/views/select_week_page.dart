import 'package:daybyday/controllers/week_controller.dart';
import 'package:daybyday/utils/app_colors.dart';
import 'package:daybyday/utils/extensions/date_extension.dart';
import 'package:daybyday/utils/formats/date_format.dart';
import 'package:daybyday/views/widgets/snackbars/error_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SelectWeekPage extends StatefulWidget {
  const SelectWeekPage({super.key});

  @override
  State<SelectWeekPage> createState() => _SelectWeekPageState();
}

class _SelectWeekPageState extends State<SelectWeekPage> {
  DateRangePickerController dateController = DateRangePickerController();
  bool _isBusy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.dominant,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.textNormal,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SfDateRangePicker(
          controller: dateController,
          view: DateRangePickerView.month,
          selectionMode: DateRangePickerSelectionMode.range,
          rangeSelectionColor: AppColors.highlight.withOpacity(0.5),
          startRangeSelectionColor: AppColors.highlight,
          endRangeSelectionColor: AppColors.highlight,
          onSelectionChanged: (DateRangePickerSelectionChangedArgs val) {
            if (dateController.selectedRange != null &&
                dateController.selectedRange!.startDate != null) {
              SelectedWeek startAndEndWeek =
                  dateController.selectedRange!.startDate!.startAndEndWeek;
              dateController.selectedRange =
                  PickerDateRange(startAndEndWeek.start, startAndEndWeek.end);
              setState(() {});
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: dateController.selectedRange == null ||
                  dateController.selectedRange!.startDate == null ||
                  dateController.selectedRange!.endDate == null ||
                  _isBusy
              ? null
              : () {
                  setState(() => _isBusy = true);
                  var controller = context.read<WeekController>();
                  controller
                      .get(context,
                          startAt: AppDateFormat.toSave
                              .format(dateController.selectedRange!.startDate!),
                          endAt: AppDateFormat.toSave
                              .format(dateController.selectedRange!.endDate!))
                      .then((value) {
                    Navigator.pop(context);
                  }).catchError((err) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        ErrorSnackbar(content: Text(err.toString())));
                    if (mounted) {
                      setState(() {
                        _isBusy = false;
                      });
                    }
                  });
                },
          backgroundColor: dateController.selectedRange == null ||
                  dateController.selectedRange!.startDate == null ||
                  dateController.selectedRange!.endDate == null ||
                  _isBusy
              ? AppColors.border
              : AppColors.highlight,
          label: Row(
            children: _isBusy
                ? [
                    Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(right: 8),
                      child: CircularProgressIndicator(
                        color: AppColors.textLight,
                      ),
                    ),
                    const Text("Carregando...")
                  ]
                : [
                    Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: const Icon(Icons.edit)),
                    const Text("Mudar a data")
                  ],
          )),
    );
  }
}
