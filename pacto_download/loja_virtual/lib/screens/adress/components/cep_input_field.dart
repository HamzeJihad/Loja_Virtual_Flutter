import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/componentescomuns/custom_iconbuton.dart';
import 'package:loja_virtual/modelos/address.dart';
import 'package:loja_virtual/modelos/cart_manager.dart';
import 'package:provider/provider.dart';
class CepInputField extends StatefulWidget {

   const CepInputField(this.address);


  final  Address address;

  @override
  _CepInputFieldState createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {
  final TextEditingController cepController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    final cartManager = context.watch<CartManager>();

    final primarycolor = Theme.of(context).primaryColor;


    if(widget.address.zipCode == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            enabled: !cartManager.loading,
            controller: cepController,
            decoration: InputDecoration(
              isDense: true,
              labelText: 'CEP',
              hintText: '74.453-610',
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
            keyboardType: TextInputType.number,
            validator: (cep){
              if(cep.isEmpty)
                return 'Campo Obrigatório';

              else if(cep.length != 10)
                return 'CEP inválido';

              return null;
            },
          ),
          if(cartManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primarycolor),
              backgroundColor: Colors.transparent,
            ),
          RaisedButton(
              onPressed: !cartManager.loading ? ()async{
                if(Form.of(context).validate()) {
                  try {
                   await  context.read<CartManager>().getAddress(cepController.text);
                  }
                  catch(e){
                    Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$e'),
                          backgroundColor: Colors.red,
                        )
                    );
                  }
                }

              }: null,
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            disabledColor: primarycolor.withAlpha(100),
            child: const Text('Buscar CEP'),

              )
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'CEP: ${widget.address.zipCode}',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CustomIconButton(
              iconData: Icons.edit,
              color: Theme.of(context).primaryColor,
              onTap: (){
                context.read<CartManager>().removeAddress();
              },
            ),
          ],
        ),
      );
    }
  }
}
