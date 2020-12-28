import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/modelos/address.dart';
import 'package:loja_virtual/modelos/cart_manager.dart';
import 'package:loja_virtual/screens/adress/components/address_input_field.dart';
import 'package:provider/provider.dart';

import 'cep_input_field.dart';


//CAMPO DE ENDEREÇO

  class AddressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),

      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Consumer<CartManager>(

          builder: (_, cartManager, __){
            final address = cartManager.address ?? Address();

            return Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Endereço de Entrega',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  CepInputField(address), //LOCAL DE COLOCAR O CEP
                    AddressInputField(address),

                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
