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
  });
}