import 'package:flutter/material.dart';
import 'package:loja_virtual/componentescomuns/custom_iconbuton.dart';
import 'package:loja_virtual/modelos/home_manager.dart';
import 'package:loja_virtual/modelos/section.dart';
import 'package:provider/provider.dart';
//TEXTO DE PROMOÇÃO, EM DESTAQUE , ETC.

class SectionHeader extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    final section = context.watch<Section>();

    //SE ESTIVERMOS EDITANDO
    if(homeManager.editing){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                initialValue: section.name,
                decoration: InputDecoration(
                  hintText: "Título",
                  isDense: true,
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
                onChanged: (text) => section.name = text,
              ),
            ),
            //BOTÃO DE REMOVER
            CustomIconButton(
              iconData: Icons.remove,
              color: Colors.white,
              onTap: (){
                homeManager.removeSection(section);
              },
            )
          ],
        ),

          if(section.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                section.error,
                style: const TextStyle(color: Colors.red),
              ),
            )
    ],
      );
    }
    else{
    return Padding(
      padding: const EdgeInsets.symmetric( vertical: 8.0),
      child: Text(
        section.name ?? "",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
    }
  }
}
