class UserRegister{

  String idUser="";
  String name="";
  String email="";
  String cpf="";
  String phone="";
  String address="";

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "idUser" : this.idUser,
      "name" : this.name,
      "email" : this.email,
      "cpf" : this.cpf,
      "phone" : this.phone,
      "address" : this.address,
    };
    return map;
  }
}