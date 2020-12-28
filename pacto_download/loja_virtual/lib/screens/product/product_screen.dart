import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/modelos/cart_manager.dart';
import 'package:loja_virtual/modelos/product.dart';
import 'package:loja_virtual/modelos/user_manager.dart';
import 'package:provider/provider.dart';

import 'components/size_widget.dart';


//TELA DE QUANDO ABRE O PRODUTO
class ProductScreen extends StatelessWidget {

  const ProductScreen(this.product);
  final Product product ;
  @override
  Widget build(BuildContext context) {

    final primaryColor = Theme.of(context).primaryColor;
    return ChangeNotifierProvider.value(
      value: product  ,
      child: Scaffold(
        appBar: AppBar(
           title: Text(product.name),
          centerTitle: true,
          actions: <Widget>[

            //BOTÃO DO ADMINISTRADOR
            Consumer<UserManager>(
              builder: (_, userManager, __){
                if(userManager.adminEnabled && !product.deleted){
                    return IconButton(
                  icon:  Icon(Icons.edit),
                  onPressed: (){
                    Navigator.of(context).pushReplacementNamed('/edit_product',
                    arguments: product
                    );
                  },
                );
                }
                else{
                  return Container();
                    }
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            AspectRatio( //FICAR AS IMAGENS QUADRADAS
              aspectRatio: 1 ,
              child: Carousel(
                images: product.images.map((url){
                  return NetworkImage(url);
                }).toList(),
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: primaryColor,
                autoplay: false ,//para o carrosel nao alterar as imagens sozinho
                //animationDuration: Duration(milliseconds: 1000),
               ),
            ),
             //INFORMAÇÕES E NOME DO PRODUTO
             Padding(
               padding: const EdgeInsets.all(16),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: <Widget>[
                   Text(
                     product.name,
                     style: TextStyle(
                       fontSize: 20,
                       fontWeight: FontWeight.w600
                     ),
                   ),
                   Padding(padding: const EdgeInsets.only(top: 8),
                   child: Text(
                     'A partir de',
                     style: TextStyle(
                       color: Colors.grey[600],
                       fontSize: 13,
                     ),
                   ),
                   ),
                   Text(
                      'R\$ ${product.basePrice.toStringAsFixed(2)}',
                     style: TextStyle(fontSize: 22.0,
                     fontWeight: FontWeight.bold,
                       color: primaryColor,
                     ),
                   ),

                   Padding(
                     padding: const EdgeInsets.only(top: 16, bottom: 8),
                     child: Text(
                       'Descrição',
                       style: TextStyle(
                         fontSize: 16.0,
                         fontWeight: FontWeight.w500
                       ),
                     ),
                   ),
                   Text(
                     product.description,
                     style: const TextStyle(
                       fontSize: 17,
                     ),
                   ),
                   if(product.deleted)
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child:const   Text(
                          'Este produto não está mais disponível',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            color: Colors.red,
                    ),
                  ),
                )
                   else
                   ...[
                     Padding(
                       padding: const EdgeInsets.only(top: 16, bottom: 8),
                       child:const   Text(
                         'Tamanhos',
                         style: TextStyle(
                             fontSize: 16.0,
                             fontWeight: FontWeight.w500
                         ),
                       ),
                     ),


                     //UM QUADRADO ATRÁS DO OUTRO SEM DEIXAR CHEGAR O FIM DA TELA, PARA NÃO DAR OVERFLOW
                     Wrap(
                       runSpacing: 8, //ESPAÇAMENTO DE COLUNAS
                       spacing: 12, //PARA UM NAO FICAR COLADO NO OUTRO LINHAS
                       children: product.sizes.map((s){
                         return SizeWidget(size: s);

                       }).toList(),
                     ),
                   ],
                   const SizedBox(height: 20.0,),


                   if(product.hasStock) //SE TIVER ESTOQUE EXIBO O BOTÃO
                   //BOTÃO DE ADICIONAR O CARRINHO
                   //PARA ANALISAR SE ESTÁ SELECIONADO O PRODUTO
                   Consumer2<UserManager, Product>(

                      builder: (_, userManager , product,__){

                          return SizedBox(height: 44,
                          child: RaisedButton(
                            onPressed: product.selectedSize != null ?(){

                            //se selecionar algo habilita o botão
                              if(userManager.isLoggedIn){
                                context.read<CartManager>().addToCart(product);
                                Navigator.of(context).pushNamed('/cart');
                              } else {
                                Navigator.of(context).pushNamed('/login');
                              }
                            } : null,
                            color: primaryColor,
                            textColor: Colors.white,
                            child: Text(
                              userManager.isLoggedIn ? //SE O USU[ARIO ESTÁ LOGADO
                                  'Adicionar ao Carrinho' : 'Entre para Comprar',
                              style: const TextStyle(fontSize: 18),


                            ),
                          ),
                          );
                      },
                   )
                 ],
               ),
             )
          ],
        ),
      ),
    );
  }
}
