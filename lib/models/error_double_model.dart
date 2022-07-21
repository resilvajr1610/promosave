import '../utils/export.dart';

double ErrorDoubleModel(item,type){
  double number;
  try {
  dynamic data = item.get(FieldPath([type]));
  number = data;
  } on StateError catch (e) {
    number = 0.0;
  }
  return number;
}