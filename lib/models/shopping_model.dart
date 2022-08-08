export '../utils/export.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingModel{

  int order=0;
  String hourRequest='';
  String idShopping="";
  String idClient="";
  String idEnterprise="";
  String logoUrl="";
  String idDelivery="";
  String nameClient="";
  String nameEnterprise="";
  String nameDelivery="";
  int quantSalgada=0;
  int quantMista=0;
  int quantDoce=0;
  double priceSalgada=0.0;
  double priceMista=0.0;
  double priceDoce=0.0;
  double totalFees=0.0;
  String addressClient='';
  String addressEnterprise='';
  double latClient=0.0;
  double lngClient=0.0;
  double latEnterprise=0.0;
  double lngEnterprise=0.0;
  String status="";
  String type="";
  int quantBagDoce=0;
  int quantBagMista=0;
  int quantBagSalgada=0;
  double totalPrice=0.0;

  ShoppingModel();

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "order"             : this.order,
      "hourRequest"       : this.hourRequest,
      "idClient"          : this.idClient,
      "idShopping"        : this.idShopping,
      "idEnterprise"      : this.idEnterprise,
      "logoUrl"           : this.logoUrl,
      "idDelivery"        : this.idDelivery,
      "nameClient"        : this.nameClient,
      "nameEnterprise"    : this.nameEnterprise,
      "nameDelivery"      : this.nameDelivery,
      "quantSalgada"      : this.quantSalgada,
      "quantMista"        : this.quantMista,
      "quantDoce"         : this.quantDoce,
      "priceSalgada"      : this.priceSalgada,
      "priceMista"        : this.priceMista,
      "priceDoce"         : this.priceDoce,
      "totalFees"         : this.totalFees,
      "addressClient"     : this.addressClient,
      "addressEnterprise" : this.addressEnterprise,
      "latClient"         : this.latClient,
      "lngClient"         : this.lngClient,
      "latEnterprise"     : this.latEnterprise,
      "lngEnterprise"     : this.lngEnterprise,
      "status"            : this.status,
      "type"              : this.type,
      "quantBagDoce"      : this.quantBagDoce,
      "quantBagMista"     : this.quantBagMista,
      "quantBagSalgada"   : this.quantBagSalgada,
      "totalPrice"        : this.totalPrice,
    };
    return map;
  }

  ShoppingModel.createId(){
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference create = db.collection("shopping");
    this.idShopping = create.doc().id;
  }
}