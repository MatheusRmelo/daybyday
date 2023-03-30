import 'package:daybyday/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SuccessSnackbar extends SnackBar {
  SuccessSnackbar({
    Key? key,
    required Widget content,
  }) : super(
          key: key,
          content: content,
          backgroundColor: AppColors.success,
          action: SnackBarAction(
            label: 'FECHAR',
            textColor: Colors.white,
            onPressed: () {},
          ),
        );
}
