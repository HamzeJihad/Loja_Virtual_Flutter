import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/modelos/admin_order_manager.dart';
import 'package:loja_virtual/modelos/admin_users_manager.dart';
import 'package:loja_virtual/modelos/cart_manager.dart';
import 'package:loja_virtual/modelos/home_manager.dart';
import 'package:loja_virtual/modelos/order.dart';
import 'package:loja_virtual/modelos/order_manager.dart';
import 'package:loja_virtual/modelos/product_manager.dart';
import 'package:loja_virtual/modelos/stores_manager.dart';
import 'package:loja_virtual/screens/adress/adress_screen.dart';
import 'package:loja_virtual/screens/base/base_screen.dart';
import 'package:loja_virtual/screens/cart/cart_screen.dart';
import 'package:loja_virtual/screens/checkout/checkout_screen.dart';
import 'package:loja_virtual/screens/confirmation/confirmation_screen.dart';
import 'package:loja_virtual/screens/edit_product/edit_product_screen.dart';
import 'package:loja_virtual/screens/login/login_screen.dart';
import 'package:loja_virtual/screens/product/product_screen.dart';
import 'package:loja_virtual/screens/select_product/selected_product_screen.dart';
import 'package:loja_virtual/screens/signup/signup_screen.dart';
import 'package:loja_virtual/services-api/cepaberto_service.dart';
import 'package:provider/provider.dart';

import 'modelos/product.dart';
import 'modelos/user_manager.dart';

void main() {
  runApp(MyApp());


}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserManager(),
        lazy: false,),
        
       ChangeNotifierProvider(
            create: (_) => ProductManager(),
        lazy: false,
       ),
      //poder acessar em qualquer local do app

        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy:  false,
        ),


        //SEMPRE QUE O USERMANAGER MODIFICAR, MODIFICA O CARTMAANGER
      ChangeNotifierProxyProvider<UserManager, CartManager>(
        create: (_) => CartManager(),
        lazy: false,

        //SEMPRE QUE O USERMANAGER FIZ ATT, O CART MAANAGER JA VAI CARREGAR O CARRINHO DO OUTRO USUARIO
        update: (_, userManager, cartManager) =>
        cartManager..updateUser(userManager),
      ),

        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
            create: (_) => OrdersManager(),
            lazy:  false,
            update: (_, userManager, ordersManager) =>
            ordersManager..updateUser(userManager.user),
        ),
        ChangeNotifierProvider(
            create: (_) => StoresManager(),
        ),

        ChangeNotifierProxyProvider<UserManager,AdminUsersManager>(
            create: (_) => AdminUsersManager(),
            lazy: false,
            update: (_, userManager, adminUsersManager)=>
          adminUsersManager..updateUser(userManager),
            ),

        ChangeNotifierProxyProvider<UserManager,AdminOrdersManager>(
          create: (_) => AdminOrdersManager(),
          lazy: false,
          update: (_, userManager, adminOrderManager)=>
          adminOrderManager..updateAdmin(userManager.adminEnabled),
        )

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Loja do Hamze',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 4, 125, 141),
          //COR DE FUNDO
          scaffoldBackgroundColor: const Color.fromARGB(255, 4, 125, 141),

          appBarTheme: const AppBarTheme(
            elevation: 0
          ),

          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

        onGenerateRoute: (settings){
          switch(settings.name){
            case '/login':
              return MaterialPageRoute(
                  builder: (_) => LoginScreen());



            case '/signup':
              return MaterialPageRoute(
                  builder: (_) => SignUpScreen());

             case '/product':
                return MaterialPageRoute(
                builder: (_) => ProductScreen(
                  settings.arguments as Product
                ));

            case '/cart':
              return MaterialPageRoute(
                  builder: (_) => CartScreen(),
                settings: settings,
              );


            case '/selected_product':
              return MaterialPageRoute(
                  builder: (_) => SelectedProductScreen());

            case '/address':
              return MaterialPageRoute(
                  builder: (_) => AddressScreen());

            case '/checkout':
              return MaterialPageRoute(
                  builder: (_) => CheckoutScreen());

            case '/confirmation':
              return MaterialPageRoute(
                  builder: (_) => ConfirmationScreen(
                    settings.arguments as Order
                  ));

            case '/edit_product':
              return MaterialPageRoute(
                  builder: (_) => EditProductScreen(
                    settings.arguments as Product,
                  ));

            case '/':
            default:
              return MaterialPageRoute(
                builder: (_) => BaseScreen(),
                settings: settings,
              );
          }
        },
      ),
    );
  }
}

