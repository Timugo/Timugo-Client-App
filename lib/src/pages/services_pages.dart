import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timugo/src/services/number_provider.dart';
import 'package:timugo/src/widgets/addDirections.dart';
import 'package:timugo/src/widgets/cardsServices.dart';
import 'package:timugo/src/widgets/cardsBarbers.dart';

import 'package:timugo/src/widgets/circularBackground.dart';

 

 
class Services extends StatefulWidget {
 
  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  @override
  Widget build(BuildContext context) {
    final servicesProvider = ServicesProvider();
    servicesProvider.getServices();
    return Scaffold(
      body:Stack(
        children: <Widget>[
          
          CircularBackGround(),
          SafeArea(

            child: SingleChildScrollView(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                    
                  //CustomAppBar(),
                  Container(
                    alignment: Alignment.center,
                    child:FlatButton.icon(
                     
                      label: Text('Dirección Actual',),
                       icon: Icon(Icons.arrow_drop_down),
                      onPressed: () => _onButtonPressed(context),
                      
                    ),
                  ),  

                  _Header(),
                  SizedBox(height: 20,),
                  CardsServices(),
                  _HeaderBarbers(),
                  CardsBarbers(),

                ],
              ) ,
            ),
          ),
          BuyButton()
        ],
      )
    ); 
    
  }

  void _onButtonPressed(BuildContext context) {
     final size = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: size*0.75,
            child: Container(
              child: AddDireccions(),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        });
  }
}


  

  



class  _Header extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start ,
        children: <Widget>[
          SizedBox(height: 20.0,),
          Text('Servicios',style:TextStyle(fontWeight:FontWeight.bold,fontSize:30.0)),
          Text('Que quieres pedir hoy?',style:TextStyle(fontWeight:FontWeight.w100,fontSize:18.0))

        ],
      ),
    );
  }
}
class  _HeaderBarbers extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start ,
        children: <Widget>[
          SizedBox(height: 20.0,),
          Text('Barberos',style:TextStyle(fontWeight:FontWeight.bold,fontSize:25.0)),
          Row(
            children: <Widget>[
              Icon(FontAwesomeIcons.fire,color: Colors.red,),
              SizedBox(width: 15.0,),
              Text('Nuestros Barberos mas Top',style:TextStyle(fontWeight:FontWeight.w100,fontSize:18.0)),
              SizedBox(width: 15.0,),
              Icon(FontAwesomeIcons.fire,color: Colors.red,)
            ],
          ),
        ],
      ),
    );
  }
}

class BuyButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 0.0,
          right: 0.0,
          child: Container(

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Pedir',style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 20.0),),
                SizedBox(width: 5.0,),
                Icon(FontAwesomeIcons.arrowRight,color: Colors.white,)
              ],
            ),
            width: size.width*0.3,
            height: 60.0,
            decoration: BoxDecoration(
              color:Colors.red,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0))
            ),
          ),
        )
      ],
    );
  }
}
