import '../Utils/colors.dart';
import '../Utils/export.dart';

class ContainerRequestsClient extends StatelessWidget {

  final onTapIcon;
  final showDetailsRequests;
  final idRequests;
  final contMixed;
  final contSalt;
  final contSweet;
  final date;
  final time;
  final enterprise;
  final type;
  final status;

  ContainerRequestsClient({
    required this.onTapIcon,
    required this.showDetailsRequests,
    required this.idRequests,
    required this.date,
    required this.time,
    required this.enterprise,
    required this.contMixed,
    required this.contSalt,
    required this.contSweet,
    required this.type,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Divider(color: PaletteColor.greyInput),
        GestureDetector(
          onTap: onTapIcon,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    width: width*0.45,
                    child: TextCustom(
                        text: 'Pedido n° $idRequests',color: PaletteColor.grey,size: 14.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: width*0.35,
                    child: TextCustom(
                        text: '$date $time',color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                    ),
                  ),
                  GestureDetector(
                    onTap: onTapIcon,
                    child: Icon(
                        showDetailsRequests==true
                            ?Icons.arrow_drop_down:Icons.arrow_right,
                        size: 30,color: PaletteColor.greyInput
                    )
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4,vertical: 5),
                    width: width*0.5,
                    child: TextCustom(
                        text: enterprise,color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.only(right: 45,top: 5,bottom: 5),
                    width: width*0.35,
                    child: TextCustom(
                        text: status,color: PaletteColor.primaryColor,size: 12.0,fontWeight: FontWeight.normal,textAlign: TextAlign.end
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        showDetailsRequests==true ?Column(
          children: [
            contMixed!=0?Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  width: width*0.45,
                  child: TextCustom(
                      text: '$contMixed x Sacola mista',color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 45),
                  child: TextCustom(
                      text: 'R\$ ${(contMixed*10)},00',color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                  ),
                ),
              ],
            ):Container(),
            contSalt !=0?Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  width: width*0.45,
                  child: TextCustom(
                      text: '$contSalt x Sacola salgada',color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 45),
                  child: TextCustom(
                      text: 'R\$ ${(contSalt*10)},00',color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                  ),
                ),
              ],
            ):Container(),
            contSweet!=0? Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  width: width*0.45,
                  child: TextCustom(
                      text: '$contSweet x Sacola Doce',color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 45),
                  child: TextCustom(
                      text: 'R\$ ${(contSweet*10)},00',color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.normal,textAlign: TextAlign.start
                  ),
                ),
              ],
            ):Container(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4,vertical: 5),
              width: width,
              child: TextCustom(
                  text: type,color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.bold,textAlign: TextAlign.start
              ),
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4,vertical: 5),
                  width: width*0.45,
                  child: TextCustom(
                      text: 'Total',color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.bold,textAlign: TextAlign.start
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 45),
                  child: TextCustom(
                      text: 'R\$ ${((contSalt*10) + (contSweet*10) + (contMixed*10)).toString()+',00'}',color: PaletteColor.grey,size: 12.0,fontWeight: FontWeight.bold,textAlign: TextAlign.start
                  ),
                ),
              ],
            ),
            status =='Entregue'? Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 45),
              child: ButtonCustom(
                  onPressed: ()=>Navigator.pushReplacementNamed(context, '/home_enterprise'),
                  text:'Avaliar',
                  size: 12,
                  colorButton: PaletteColor.primaryColor,
                  colorText: PaletteColor.white,
                  colorBorder: PaletteColor.primaryColor,
                  customHeight: 0.05,
                  customWidth: 0.3,
              )
            ):Container(),
          ],
        ):Container(),
      ],
    );
  }
}
