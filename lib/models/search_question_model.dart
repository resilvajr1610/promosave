import '../Utils/export.dart';

class SearchQuestionModel{

  String _question="";

  SearchQuestionModel.fromSnapshot(DocumentSnapshot snapshot):_question = snapshot['question'];

  SearchQuestionModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.question = documentSnapshot["question"];
  }

  String get question => _question;

  set question(String value) {
    _question = value;
  }
}
