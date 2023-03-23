import 'package:daybyday/utils/app_colors.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard(
      {super.key, required this.title, required this.message});
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(16)),
      child: Stack(children: [
        Positioned.fill(
          child: Row(children: [
            Container(
              width: 80,
              height: 80,
              margin: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: AppColors.secondaryLight),
              child: Icon(Icons.book_outlined),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Text(message,
                      style:
                          TextStyle(color: AppColors.textLight, fontSize: 16))
                ],
              ),
            ),
          ]),
        ),
        Positioned(
          child: Icon(Icons.error_outlined, color: AppColors.textLight),
          right: 1,
          top: 1,
        )
      ]),
    );
  }
}
