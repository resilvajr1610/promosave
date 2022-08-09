class UserModel{

  String idUser="";
  String name="";
  String email="";
  String cpf="";
  String phone="";
  DateTime? date;

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "idUser" : this.idUser,
      "name" : this.name,
      "email" : this.email,
      "cpf" : this.cpf,
      "phone" : this.phone,
      "date" : this.date,
    };
    return map;
  }
}