import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/modelos/page_manager.dart';
import 'package:loja_virtual/modelos/user_manager.dart';
import 'package:loja_virtual/screens/admin_orders/admin_orders_screen.dart';
import 'package:loja_virtual/screens/admin_users/admin_user_screen.dart';
import 'package:loja_virtual/screens/home/home_screen.dart';
import 'package:loja_virtual/screens/orders/orders_screen.dart';
import 'package:loja_virtual/screens/products/products_screen.dart';
import 'package:loja_virtual/screens/stores/stores_screen.dart';
import 'package:provider/provider.dart';
import 'package:loja_virtual/componentescomuns/custom_drawer/custom_drawer.dart';

class BaseScreen  extends StatefulWidget {

  //VAI CONTROLAR O PAGEVIEW
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();


  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(

      create: (_) => PageManager(pageController),

      child: Consumer<UserManager>(
        builder: (_, userManager, __){

          return PageView(

            physics: const NeverScrollableScrollPhysics(), //IMPEDIR DE MOVIMENTAR A TELA ARRASTANDO

            controller: pageController, //o controlador do PAGEVIEW É O PAGECONTROLLER
            children: <Widget>[

              //VAI TER TODAS AS FERRAMENTAS DE INICIO, PEDIDOS, AJUDA, ETC;
              HomeScreen(),

              ProductScreen(),


                //VAI TER TODAS AS FERRAMENTAS DE INICIO, PEDIDOS, AJUDA, ETC;
              OrdersScreen(),

             StoresScreen(),

              if(userManager.adminEnabled)
                ...[
                 AdminUsersScreen(),

                  AdminOrdersScreen(),
                ]
            ],
          );
        },
      ),
    );   //ALTERNAR ENTRE TELAS

  }
}
