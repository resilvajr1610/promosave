import '../utils/export.dart';

class DrawerCustom extends StatelessWidget {

  String enterprise;
  final photo;
  bool showLower;

  DrawerCustom({required this.enterprise, required this.photo,this.showLower=false});

  @override
  Widget build(BuildContext context) {

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        width: width*0.7,
        height: height,
        color: Colors.white,
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            SafeArea(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: photo==null ? CircleAvatar(
                        backgroundColor: PaletteColor.greyInput,
                        child: Icon(Icons.account_circle,color: PaletteColor.white,size: 40,),
                    ):CircleAvatar(
                      backgroundColor: PaletteColor.greyInput,
                      backgroundImage: NetworkImage(photo),
                    ),
                  ),
                  Container(
                    width: width*0.45,
                    child: TextCustom(
                        text: enterprise.toUpperCase(),
                        size: 15.0,
                        color: PaletteColor.primaryColor,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: height*0.08),
            TitleDrawer(
              onTap: ()=>Navigator.pushNamed(context, '/navigation'),
              title: 'Home',
              icon: Icons.home_outlined,
            ),
            TitleDrawer(
              onTap: ()=>Navigator.pushNamed(context, '/profile'),
              title: 'Perfil',
              icon: Icons.account_circle_outlined,
            ),
            TitleDrawer(
              onTap: ()=>Navigator.pushNamed(context, '/questions'),
                title: 'Perguntas frequentes',
                icon: Icons.help_outline,
            ),
            TitleDrawer(
              onTap: ()=>Navigator.pushNamed(context, "/who"),
                title: 'Quem Somos',
                icon: Icons.people_outline,
            ),
            Spacer(),
            GestureDetector(
              onTap: (){
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Container(
                padding: EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                width: width*0.7,
                child: Icon(Icons.logout,color: PaletteColor.primaryColor)
              ),
            ),
            showLower?SizedBox(height: height*0.1,):Container()
          ],
        ),
      ),
    );
  }
}
