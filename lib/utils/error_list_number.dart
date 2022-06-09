import '../utils/export.dart';

int ErrorListNumber(item,type){
  int number;
  try {
  dynamic data = item.get(FieldPath([type]));
  number = data;
  } on StateError catch (e) {
    number = 0;
  }
  return number;
}