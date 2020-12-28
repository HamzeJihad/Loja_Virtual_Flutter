import 'package:flutter/material.dart';
import 'package:loja_virtual/modelos/order.dart';
import 'package:loja_virtual/screens/orders/components/order_product_tile.dart';

import '../caneled_order_dialog.dart';
import '../export_address_dialog.dart';

class OrderTile extends StatelessWidget {
//CARD DOS MEUS PEDIDOS

  const OrderTile(this.order,{this.showControls  = false});

  final bool  showControls;
  final Order order;

  @override
  Widget build(BuildContext context) {

    final primaryColor = Theme.of(context).primaryColor;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  order.formattedId,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),

                Text(
                  'R\$ ${order.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Text(
              order.statusText, //status atual, que está na order
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: order.status == Status.canceled ?
                  Colors.red :
                  primaryColor,
                  fontSize: 14
              ),
            ),
          ],
        ),
        children: <Widget>[
          Column(
            children: order.items.map((e){
              return OrderProductTile(e);
            }).toList(),
          ),
         if(showControls && order.status != Status.canceled)
           SizedBox(
             height: 50,
             child: ListView(
               scrollDirection: Axis.horizontal,
               children: <Widget>[
                 FlatButton(

                     onPressed: (){
                       showDialog(context: context,
                       builder: (_) => CanceledOrderDialog(order)
                       );
                     } ,
                    textColor: Colors.red,
                     child: Text('Cancelar'),
                 ),

                 FlatButton(
                   onPressed: order.back ,
                   child: Text('Recuar'),
                 ),

                 FlatButton(
                   onPressed: order.advanced,
                   child: Text('Avançar'),
                 ),

                 FlatButton(
                   onPressed:(){
                       showDialog(context: context,
                           builder: (_) => ExportAddressDialog(order.address)
                       );
                   } ,
                   textColor: primaryColor,
                   child: Text('Endereço'),
                 ),
               ],
             ),
           )
          ],
        ),
      );
    }
  }