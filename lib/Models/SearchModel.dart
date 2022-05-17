import '../Utils/export.dart';

class SearchModel{

  String _name="";

  SearchModel.fromSnapshot(DocumentSnapshot snapshot):_name = snapshot['name'];

  SearchModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.name = documentSnapshot["name"];
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}
