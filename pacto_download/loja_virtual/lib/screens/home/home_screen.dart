import 'package:flutter/material.dart';
import 'package:loja_virtual/componentescomuns/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/modelos/home_manager.dart';
import 'package:loja_virtual/modelos/user_manager.dart';
import 'package:loja_virtual/screens/home/componentes/add_section_widget.dart';
import 'package:provider/provider.dart';

import 'componentes/Section_List.dart';
import 'componentes/section_staggered.dart';

//TELA INICIAL - LOJA DA PACTO  - CARRINHO E EDITE 

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),

        //EFEITOS COM A BARRA
      body: Stack(
        children: <Widget>[

          Container(
            //DAR O EFEITO DEGRADê
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  //COR DE FUNDO
                 const  Color.fromARGB(255, 211, 118, 130),
                  const Color.fromARGB(255, 253, 181, 168)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            ),
          ),
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              snap: true,
              floating: true,
              backgroundColor: Colors.transparent,
              elevation:  0, //PARA NAO TER MAIS SOMBRA
              flexibleSpace: const FlexibleSpaceBar(
                title: Text('Loja do Hamze'),
                centerTitle: true,
              ),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.shopping_cart),
                    color: Colors.white,

                    //SE CLICAR NO BOTÃO DO CARRINHO SERÁ REDIRECIONADO PARA A TELA DO CARRINHO
                    onPressed: () => Navigator.of(context).pushNamed('/cart'),
                ),
                Consumer2<UserManager, HomeManager>(
                  builder: (_, userManager,homeManager, __){

                    if(userManager.adminEnabled && !homeManager.loading) {

                      if(homeManager.editing){
                              return  PopupMenuButton(
                                onSelected: (e){
                                  if(e == 'Salvar'){
                                      homeManager.saveEditing();
                                  }
                                  else{
                                      homeManager.discardEditing();
                                  }
                                },
                              itemBuilder: (_){
                                return ['Salvar', 'Descartar'].map((e) {
                                    return PopupMenuItem(
                                    value: e,
                                    child: Text(e),
                                     );
                                }).toList();
                                },
                              );
                      }
                      else{
                        return IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: homeManager.enterEditing,
                        );
                      }
                    }
                    else return Container();
                  },
                )
              ],
            ),
            SliverToBoxAdapter(
              child: Container(
               // height: 2000,
                //width: 200,
              ),
            ),
            Consumer<HomeManager>(
              builder: (_, homeManager, __){
                if(homeManager.loading){

                  //SE TIVESSE PASSADO DIRETO O LINEARPROGRESS DARIA ERRO, POR CAUSA DO SILVER
                  return SliverToBoxAdapter (
                    child: LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      backgroundColor: Colors.transparent,
                    ),
                  );
                }
                final List<Widget> children = homeManager.sections.map<Widget>(
                        (section) {
                  switch(section.type){
                    case 'List':
                      return SectionList(section);

                    case 'Staggered':
                        return SectionStaggered(section);

                    default:
                      return  Container();
                  }

                }).toList();

                if(homeManager.editing)
                  children.add(AddSectionWidget(homeManager));
                 return SliverList(
                delegate: SliverChildListDelegate(children),

                 );
            }
            )
          ],
        ),
  ],
      ),
    );
  }
}
