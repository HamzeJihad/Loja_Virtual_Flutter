import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/modelos/itens_size.dart';
import 'package:loja_virtual/modelos/product.dart';
import 'package:provider/provider.dart';
//OS RETANGULOS ONDE FICAM OS PREÇOS E TAMANHOS DOS PRODUTOS

class SizeWidget extends StatelessWidget {

  const SizeWidget({this.size});

  final ItemSize size;
  @override
  Widget build(BuildContext context) {

    final product = context.watch<Product>();

    //SE  O PRODUTO ESTÁ SELECIONADO OU NÃO
    final selected = size == product.selectedSize;

    Color color;
    if(!size.hasStock)
      color = Colors.red.withAlpha(50);
    else if(selected)
      color = Theme.of(context).primaryColor;

    else
      color = Colors.grey;
    
    
    
    return GestureDetector(

      onTap: (){

        if(size.hasStock){
          //se tiver estoque o produto foi selecionado e pode mudar para a cor pirmária
          product.selectedSize = size;
        }
      },
      child: Container(

        decoration: BoxDecoration(
          border: Border.all(
            color: color,

          )
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            Container(
              color:  color,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8 ),
              child: Text(
                size.name,
                style: TextStyle(color: Colors.white),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal:16 ),
              child: Text(
                'R\$ ${size.price.toStringAsFixed(2)}',
                style: TextStyle(color:   color,),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
