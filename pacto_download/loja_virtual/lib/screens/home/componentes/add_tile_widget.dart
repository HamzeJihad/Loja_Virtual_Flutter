import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loja_virtual/modelos/section.dart';
import 'package:loja_virtual/modelos/section_item.dart';
import 'package:loja_virtual/screens/edit_product/components/image_source_sheet.dart';
import 'package:provider/provider.dart';

//CAMPO DE ADICIONAR NOVA IMAGEM NA HOME
class AddTileWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final section = context.watch<Section>();
    void onImageSelected(File file ){
        section.addItem(SectionItem(image: file));
        Navigator.of(context).pop();
    }
    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: (){
          showModalBottomSheet(
              context: context,
              builder: (context) => ImageSourceSheet(onImageSelected: onImageSelected),);
        },
        child: Container(
          color: Colors.white.withAlpha(30),
          child:Icon(
            Icons.add,
            color: Colors.white,
          ) ,
        ),
      ),
    );
  }
}
