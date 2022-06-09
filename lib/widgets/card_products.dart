import '../utils/export.dart';

class CardProducts extends StatelessWidget {
  int available;
  final byPrice;
  final inPrice;
  final description;
  final photoUrl;
  final product;
  final onTapMore;
  final onTapDelete;
  final selectItem;

  CardProducts({
    required this.available,
    required this.byPrice,
    required this.inPrice,
    required  this.description,
    required  this.photoUrl,
    required  this.product,
    required  this.onTapMore,
    required  this.onTapDelete,
    required  this.selectItem,
  });

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return available>0? Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder( borderRadius:BorderRadius.circular(0)
            ),
            child: Container(
              height: 130,
              width: width*0.5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 80,
                    width:  width*0.5,
                    child: Image.network(photoUrl,
                      alignment: Alignment.center,
                      fit: BoxFit.fitWidth,
                      height: 80,
                      width:  width*0.5,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                strokeWidth: 1,
                                color: PaletteColor.primaryColor,
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                              TextCustom(text: 'Carregando imagem',size: 12.0,color: PaletteColor.primaryColor,fontWeight: FontWeight.normal,textAlign:TextAlign.center,)
                            ],
                          ),
                        );
                      }),
                  ),
                  Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.symmetric(horizontal: 6,vertical: 2),
                      width: width,
                      decoration: BoxDecoration(
                        color: PaletteColor.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextCustom(fontWeight: FontWeight.bold,color: PaletteColor.grey, text: 'Sacola '+ product, size: 12.0,textAlign: TextAlign.center,),
                          Row(
                            crossAxisAlignment:CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextCustom(fontWeight: FontWeight.bold,color: PaletteColor.greyInput, text: '$available Disponíveis', size: 10.0,textAlign: TextAlign.center,),
                                  TextCustom(fontWeight: FontWeight.bold,color: PaletteColor.greyInput, text: '', size: 10.0,textAlign: TextAlign.center,),
                                ],
                              ),
                              Spacer(),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('de $inPrice',style: TextStyle(
                                    decoration: TextDecoration.lineThrough,decorationColor: PaletteColor.grey,
                                    fontFamily: 'Nunito',color: PaletteColor.grey,fontSize: 10.0,fontWeight: FontWeight.normal,)
                                  ),
                                  TextCustom(fontWeight: FontWeight.bold,color: PaletteColor.green, text: 'por $byPrice', size: 10.0,textAlign: TextAlign.center,),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 130,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextCustom(text: 'O que pode conter:',size: 12.0,color: PaletteColor.grey,fontWeight: FontWeight.bold,textAlign:TextAlign.center,),
                ),
                Container(
                  width: width*0.4,
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextCustom(text: description,size: 12.0,color: PaletteColor.grey,fontWeight: FontWeight.normal,textAlign:TextAlign.center,),
                ),
                Spacer(),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onTapMore,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: PaletteColor.primaryColor
                        ),
                        child: Icon(Icons.add_shopping_cart,color: PaletteColor.white,size: 20,)),
                    ),
                    selectItem>0?Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TextCustom(text: selectItem.toString(),size: 16.0,color: PaletteColor.grey,fontWeight: FontWeight.normal,textAlign:TextAlign.center,),
                    ):Container(),
                    selectItem>0?GestureDetector(
                      onTap: onTapDelete,
                      child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: PaletteColor.red
                          ),
                          child: Icon(Icons.delete_forever,color: PaletteColor.white,size: 20,)),
                    ):Container(),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ):Container();
  }
}
