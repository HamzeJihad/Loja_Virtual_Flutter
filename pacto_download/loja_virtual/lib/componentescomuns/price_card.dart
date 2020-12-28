import 'package:flutter/material.dart';
import 'package:loja_virtual/modelos/cart_manager.dart';
import 'package:provider/provider.dart';


//CARTÃO DE PREÇO DE CARRINHO, COM A OPÇÃO DE IR PARA ENTREGA/PAGAMENTO

class PriceCard extends StatelessWidget {

  const PriceCard({this.buttonText, this.onPressed});

  final String buttonText;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {

    final cartManager = context.watch<CartManager>();
    final productsPrice   = cartManager.productPrice;
    final deliveryPrice = cartManager.deliveryPrice;
    final totalPrice = cartManager.totalPrice;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding:  const EdgeInsets.fromLTRB(16,16 ,16 ,4 ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Resumo do Pedido",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.w600,
                fontSize: 16,
                ),
              ),
              const SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('SubTotal',
                    style: TextStyle(fontSize: 16.0),),
                    Text('R\$ ${productsPrice.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16.0,
                    color: Theme.of(context).primaryColor),),
                  ],
              ),
              const Divider(), //espaço
              if(deliveryPrice != null)
                ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Entrega',
                        style: TextStyle(fontSize: 16.0),),
                      Text('R\$ ${deliveryPrice.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16.0,
                            color: Theme.of(context).primaryColor),),
                    ],
                  ),
                  const Divider(), //ENTREGA
                ],
              const SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  Text('Total',
                      style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                      '${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16.0,
                    color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8,),
              RaisedButton(
                  onPressed: onPressed,

                color: Theme.of(context).primaryColor,
                disabledColor: Theme.of(context).primaryColor.withAlpha(100),
                textColor: Colors.white,
                child: Text(buttonText),
              )

            ],
        ),
      ),
    );
  }
}
