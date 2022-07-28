class Arguments {
  final String idUser;
  final String banner;
  final String enterpriseName;
  final String enterprisePicture;
  final String status;
  final String startHours;
  final String finishHours;
  final String address;
  final String byPriceDoce;
  final String byPriceMista;
  final String byPriceSalgada;
  final int quantDoce;
  final int quantMista;
  final int quantSalgada;
  final double lat;
  final double lgn;
  final double feesKm;

  final String homeAddress;
  final String homeCity;
  final String homeVillage;
  final String homeStreet;
  final double homeLat;
  final double homeLng;

  final String workAddress;
  final String workCity;
  final String workVillage;
  final String workStreet;
  final double workLat;
  final double workLng;

  final String otherAddress;
  final String otherCity;
  final String otherVillage;
  final String otherStreet;
  final double otherLat;
  final double otherLng;

  Arguments({
    required this.idUser,
    required this.banner,
    required this.enterpriseName,
    required this.enterprisePicture,
    required this.status,
    required this.startHours,
    required this.finishHours,
    required this.address,
    required this.byPriceDoce,
    required this.byPriceMista,
    required this.byPriceSalgada,
    required this.quantDoce,
    required this.quantMista,
    required this.quantSalgada,
    required this.lat,
    required this.lgn,
    required this.feesKm,
    this.homeAddress = '',
    this.homeCity = '',
    this.homeVillage = '',
    this.homeStreet = '',
    this.homeLat = 0.0,
    this.homeLng = 0.0,
    this.workAddress = '',
    this.workCity = '',
    this.workVillage = '',
    this.workStreet = '',
    this.workLat = 0.0,
    this.workLng = 0.0,
    this.otherAddress = '',
    this.otherCity = '',
    this.otherVillage = '',
    this.otherStreet = '',
    this.otherLat = 0.0,
    this.otherLng = 0.0,
  });
}