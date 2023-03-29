import 'package:daybyday/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ErrorSnackbar extends SnackBar {
  ErrorSnackbar({
    Key? key,
    required Widget content,
  }) : super(
          key: key,
          content: content,
          backgroundColor: AppColors.error,
          action: SnackBarAction(
            label: 'FECHAR',
            textColor: Colors.white,
            onPressed: () {},
          ),
        );
}
