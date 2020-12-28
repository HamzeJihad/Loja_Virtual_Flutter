import 'package:flutter/material.dart';
import 'package:loja_virtual/componentescomuns/custom_drawer/custom_drawer_header.dart';
import 'package:loja_virtual/componentescomuns/custom_drawer/drawer_tile.dart';
import 'package:loja_virtual/modelos/user_manager.dart';
import 'package:provider/provider.dart';


class CustomDrawer extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          Container(

            //DEGRADÊ DE CORES
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255,203, 236, 241),
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            ),
          ),
      ListView(
        children: <Widget>[

          const Divider(),
        CustomDrawerHeader(),
          //ARQUIVO RESPONSÁVEL PELOS ICONES DAS OPÇÕES AJUDA, PEDIDOS, ETC.
          DrawerTile(iconData: Icons.home, title:  'Inicio',page: 0,),
          DrawerTile(iconData: Icons.list, title:  'Produtos', page: 1,),
          DrawerTile(iconData: Icons.playlist_add_check, title:  'Meus Pedidos', page: 2,),
          DrawerTile(iconData: Icons.location_on, title:  'Lojas',page: 3,),

        Consumer<UserManager>(
              builder: (_, userManager, __){

                if(userManager.adminEnabled){
                  return Column(

                    children: <Widget>[
                     const  Divider(),

                      DrawerTile(iconData: Icons.settings, title:  'Usuários', page: 4,),
                      DrawerTile(iconData: Icons.settings, title:  'Pedidos',page: 5,),

                    ],
                      );
                          }
                  else{
                    return Container();
                }

              }
        )
        ],
    ),
    ],

    ),
    );
  }
}
