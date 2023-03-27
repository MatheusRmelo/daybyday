import 'package:daybyday/models/day.dart';
import 'package:daybyday/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayCard extends StatelessWidget {
  const DayCard(
      {super.key,
      required this.date,
      this.isActive = false,
      required this.onPressed});
  final DateTime date;
  final bool isActive;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(),
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: isActive ? AppColors.highlight : AppColors.dominant,
            borderRadius: BorderRadius.circular(16),
            border: isActive ? null : Border.all(color: AppColors.border)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('E').format(date),
                style: TextStyle(
                    fontSize: 16,
                    color:
                        isActive ? AppColors.textLight : AppColors.textNormal),
              ),
              Text(
                date.day.toString(),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        isActive ? AppColors.textLight : AppColors.textNormal),
              )
            ]),
      ),
    );
  }
}
