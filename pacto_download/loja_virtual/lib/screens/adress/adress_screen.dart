import 'package:flutter/material.dart';
import 'package:loja_virtual/componentescomuns/price_card.dart';
import 'package:loja_virtual/modelos/cart_manager.dart';
import 'package:provider/provider.dart';

import 'components/address_card.dart';

class AddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrega'),
        centerTitle: true,
      ),
      body: ListView(
         children: <Widget>[
           AddressCard(),   //MONTAR O CAMPO DE ENDEREÇO SEPARADo
          Consumer<CartManager>(
            builder: (_, cartManager,__){
              return  PriceCard(
              buttonText: 'Continuar para o Pagamento',

              onPressed: cartManager.isAddressValid ?(){
                Navigator.of(context).pushNamed('/checkout');

          }: null,
          ); //SUBTOTAL, TOTAL
          }
          )
         ],
      ),
    );
  }
}
