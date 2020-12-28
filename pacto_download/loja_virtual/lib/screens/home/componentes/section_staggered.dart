import 'package:flutter/material.dart ';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loja_virtual/modelos/home_manager.dart';
import 'package:loja_virtual/modelos/section.dart';
import 'package:loja_virtual/screens/home/componentes/add_tile_widget.dart';
import 'package:loja_virtual/screens/home/componentes/section_header.dart';
import 'package:provider/provider.dart';
import 'item_tile.dart';

class SectionStaggered extends StatelessWidget {

  const SectionStaggered(this.section);

  final Section section;

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return ChangeNotifierProvider.value(
      value: section,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SectionHeader(),

           Consumer<Section>(
             builder: (_, section, __){
               return  StaggeredGridView.countBuilder(
                 padding: EdgeInsets.zero,
                 shrinkWrap: true, //QUERO QUE ESSA LISTVIEW SEJA A MENOR POSSIVEL
                 crossAxisCount: 4, //UNIDADES NA HORIZONTAL
                 physics: const  NeverScrollableScrollPhysics(),
                 itemCount: homeManager.editing
                     ? section.items.length + 1
                     : section.items.length,
                 itemBuilder: (_, index){
                   if(index <section.items.length )
                     return ItemTile( //VAI EXIBIR A IMAGEM E COLOCAR UM GESTURE DETECTOR PARA QUANDO CLICAR
                         section.items[index]);
                   else
                     return AddTileWidget();
                 },
                 staggeredTileBuilder: (index) => StaggeredTile.count(2, index.isEven ? 2: 1 ),
                 mainAxisSpacing: 4,
                 crossAxisSpacing: 4,
               );
             },
           )
            ],
        ),
      ),
    );
  }
}