export '../utils/export.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingModel{

  String idShopping="";
  String idUser="";
  int quantSalgada=0;
  int quantMista=0;
  int quantDoce=0;
  String priceSalgada="";
  String priceMista="";
  String priceDoce="";
  String status="";

  ShoppingModel();

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "idUser"      : this.idUser,
      "idShopping"  : this.idShopping,
      "quantSalgada": this.quantSalgada,
      "quantMista"  : this.quantMista,
      "quantDoce"   : this.quantDoce,
      "priceSalgada": this.priceSalgada,
      "priceMista"  : this.priceMista,
      "priceDoce"   : this.priceDoce,
      "status"      : this.status
    };
    return map;
  }

  ShoppingModel.createId(){
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference create = db.collection("shopping");
    this.idShopping = create.doc().id;
  }
}