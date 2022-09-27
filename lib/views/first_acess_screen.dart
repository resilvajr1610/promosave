import 'package:flutter/material.dart';
import 'package:promosavecliente/models/shopping_model.dart';
import 'package:provider/provider.dart';

import '../service/app_settings.dart';

class FirstAcessScreen extends StatefulWidget {
  const FirstAcessScreen({Key? key}) : super(key: key);

  @override
  State<FirstAcessScreen> createState() => _FirstAcessScreenState();
}

class _FirstAcessScreenState extends State<FirstAcessScreen> {

  int currentIndex=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: PageView.builder(
              onPageChanged: (index){
                setState(() {
                  currentIndex = index;
                });
              },
              itemCount: 3,
              itemBuilder:(context, index) {
                return Container(
                  height:MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize:MainAxisSize.min,
                    children: [
                      currentIndex!=2?CircleAvatar(
                        radius: 55,
                        backgroundColor: PaletteColor.primaryColor,
                        child: Icon(currentIndex==0?Icons.shopping_bag_outlined:Icons.percent,size: 55,color: PaletteColor.white,),
                      ):Icon(Icons.check_circle_outline,color: PaletteColor.primaryColor,size: 60,),
                      SizedBox(height: 40,),
                      currentIndex!=2
                          ?TextCustom(text: currentIndex==0?'Bem-vindo':'Ofertas', color: PaletteColor.primaryColor,size: 32.0,fontWeight: FontWeight.bold,)
                          :Container(),
                      currentIndex!=2
                          ?Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child: TextCustom(text: currentIndex==0?'ao PromoSave, aqui você encontrará os melhores alimentos nos melhores preços 😋 vamos combater o desperdício juntos?'
                            :'Após o cadastro, você terá acesso às ofertas! Aí é só aproveitar e escolher o que deseja e adicionar à sacola 😁',color: PaletteColor.grey,size: 18.0,maxLines: 7,textAlign: TextAlign.center,),
                          ):TextCustom(text: 'Viu como é fácil?\nAgora é só se cadastrar e aproveitar as melhores ofertas.',
                          color: PaletteColor.primaryColor,size: 24.0,maxLines: 7,textAlign: TextAlign.center,fontWeight: FontWeight.bold),
                      currentIndex!=2?SizedBox(height: MediaQuery.of(context).size.height*0.2):SizedBox(height: MediaQuery.of(context).size.height*0.1),
                      currentIndex==2?TextButton(
                          onPressed: (){
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: ( BuildContext context) => InitialScreen()
                                )
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: PaletteColor.primaryColor,
                             shape: StadiumBorder()
                          ),
                          child: Text(' Começar agora ',style: TextStyle(fontSize: 20,color: PaletteColor.white),
                          ),
                      ):Container(),
                      currentIndex==2?SizedBox(height: MediaQuery.of(context).size.height*0.1):Container(),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 8,
                              backgroundColor: currentIndex==0?PaletteColor.primaryColor:PaletteColor.greyInput,
                            ),
                            SizedBox(width: 10),
                            CircleAvatar(
                              radius: 8,
                              backgroundColor: currentIndex==1?PaletteColor.primaryColor:PaletteColor.greyInput,
                            ),
                            SizedBox(width: 10),
                            CircleAvatar(
                              radius: 8,
                              backgroundColor: currentIndex==2?PaletteColor.primaryColor:PaletteColor.greyInput,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              })
            ),
        ],
      ),
    );
  }
}
