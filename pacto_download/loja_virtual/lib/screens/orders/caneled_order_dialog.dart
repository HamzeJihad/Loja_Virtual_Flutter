import 'package:flutter/material.dart';
import 'package:loja_virtual/modelos/order.dart';


//CONFIRMAÇÃO DE CANCELAMENTO DE PRODUTO

class CanceledOrderDialog extends StatelessWidget {

  const CanceledOrderDialog(this.order);

  final Order order;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cancelar ${order.formattedId}?'),
      content: const Text('Esta ação não poderá ser desfeita!'),
      actions: <Widget>[
        FlatButton(
            onPressed:(){
              order.cancel();
              Navigator.of(context).pop();
              },
            textColor: Colors.red,
            child: const Text('Cancelar pedido'),
        ),
      ],
    );
  }
}
