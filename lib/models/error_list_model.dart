
import 'package:cloud_firestore/cloud_firestore.dart';

List ErrorListModel(item,type){
  List list;
  try {
  dynamic data = item.get(FieldPath([type]));
  list = data;
  } on StateError catch (e) {
    list = [];
  }
  return list;
}