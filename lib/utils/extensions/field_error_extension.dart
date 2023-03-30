import 'package:daybyday/models/field_error.dart';

extension FieldErrorExtension on List<FieldError> {
  String? getErrorWithCode(String code) {
    int index = indexWhere((element) => element.code == code);
    if (index == -1) return null;
    return this[index].message;
  }
}
