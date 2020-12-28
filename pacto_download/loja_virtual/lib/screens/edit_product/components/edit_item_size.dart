import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/componentescomuns/custom_iconbuton.dart';
import 'package:loja_virtual/modelos/itens_size.dart';


class EditItemSize extends StatelessWidget {

  const EditItemSize({Key key , this.size, this.onRemove,this.onMoveDown, this.onMoveUp}) : super(key: key);

  final ItemSize size;

  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onRemove;
  @override
  Widget build(BuildContext context) {
    return Row(

      children: <Widget>[
        Expanded(
          flex: 30,
          child: TextFormField(
          initialValue: size.name,
            decoration: const InputDecoration(
              labelText : 'Título',
              isDense: true,
            ),
            validator: (name){
            if(name.isEmpty)
              return 'Inválido';
              return null;
            },
            onChanged: (name) => size.name = name,
          ),
        ),
        const SizedBox(width: 4,),
        Expanded(
          flex: 30,
          child: TextFormField(
          initialValue: size.stock?.toString(),
            decoration: const InputDecoration(
              labelText: 'Estoque',
              isDense: true,
            ),
            validator: (stock){
              if(int.tryParse(stock) == null)
                return 'Inválido';
              return null;
            },
            keyboardType: TextInputType.number,
            onChanged: (stock) => size.stock = int.tryParse(stock),
          ),
        ),
        const SizedBox(width: 4,),
        Expanded(
          flex: 40,
          child: TextFormField(
            initialValue: size.price?.toStringAsFixed(2),
            decoration: const InputDecoration(
              labelText: 'Preço',
              isDense: true,
              prefixText: 'R\$',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (price){
              if(num.tryParse(price) == null)
                return 'Inválido';
              return null;
            },
            onChanged: (price) => size.price = num.tryParse(price),
          ),
        ),
        CustomIconButton(
          iconData: Icons.remove,
          color: Colors.red,
          onTap: onRemove,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_up,
          color: Colors.black,
          onTap: onMoveUp,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_down,
          color: Colors.black,
          onTap: onMoveDown,
        ),


      ],
    );
  }
}
