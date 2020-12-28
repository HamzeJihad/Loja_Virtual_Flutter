import 'package:flutter/material.dart';
import 'package:loja_virtual/componentescomuns/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/modelos/product.dart';
import 'package:loja_virtual/modelos/product_manager.dart';
import 'package:loja_virtual/modelos/user_manager.dart';
import 'package:loja_virtual/screens/products/components/product_listtitle.dart';
import 'package:provider/provider.dart';

import 'components/searchdialog.dart';

class ProductScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: CustomDrawer(),
      appBar: AppBar(

        //NOME ENCIMA  DOS PRODUTOS, AO LADO DA BARRA DE PESQUISA
        title: Consumer<ProductManager>(
          builder: (_,productManager, __){
            if(productManager.search.isEmpty){
              return const Text('Produtos');
            }
            else{
              return  LayoutBuilder(
                  builder: (_, constraints){

                     return GestureDetector(
                       onTap: () async {

                         final search = await  showDialog<String>(context: context,
                             builder: (_) => SearchDialog(

                               productManager.search
                             ));

                         if(search != null){
                           productManager.search = search;
                         }
                       },
                       child: Container(
                          //PARA ALTERAR A PESQUISA CLICANDO NO TEXTO
                           width: constraints.biggest.width,

                           child: Text(productManager.search,
                           textAlign: TextAlign.center,)),
                     );;
                  }
                  );
            }
          },
        ),
        centerTitle: true,

        //BOTOES DE PESQUISA
        actions: <Widget>[

        Consumer<ProductManager>(
          builder: (_, productManager, __){
            if(productManager.search.isEmpty){
            return  IconButton(
                  icon: Icon(Icons.search) ,
                  onPressed: () async{

                    final search = await  showDialog<String>(context: context,
                        builder: (_) => SearchDialog(
                            productManager.search
                        ));

                    if(search != null){
                      productManager.search = search;
                    }
                  },
              );
            }
              else {

              return IconButton(
                  icon: Icon(Icons.close) ,
                  onPressed: () async{

                    productManager.search = '';

                  },
              );
            }

          },
        ),
          //BOTÃO DO ADMINISTRADOR
          Consumer<UserManager>(
            builder: (_, userManager, __){
              if(userManager.adminEnabled){
                return IconButton(
                  icon:  Icon(Icons.add),
                  onPressed: (){
                    Navigator.of(context).pushNamed(
                      '/edit_product',

                    );
                  },
                );
              }
              else{
                return Container();
              }
            },
          ) ,

        ],
      ),

      body: Consumer<ProductManager>(
        builder: (_,productManager, __){
          final filterProducts = productManager.filterProducts;
         return ListView.builder(
           itemCount: productManager.filterProducts.length,
              itemBuilder: (_, index){

              return  ProductListTile(productManager.filterProducts[index]);
              }
              );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: (){
             Navigator.of(context).pushNamed('/cart');
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
