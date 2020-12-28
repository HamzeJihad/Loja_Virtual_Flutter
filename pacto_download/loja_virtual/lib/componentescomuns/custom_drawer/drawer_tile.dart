import 'package:flutter/material.dart';
import 'package:loja_virtual/modelos/page_manager.dart';
import 'package:provider/provider.dart';
class DrawerTile extends StatelessWidget {


  //VOU PASSAR POR REFERENCIA O BOTAO E O TEXTO
 const  DrawerTile({this.iconData, this.title,this.page});

  //PARA PASSAR O ICONE QUE VOU QUERER
  final IconData iconData;


  //O NOME DO QUE VEM ANTES DO ICONE. (SAIR) AI VEM O ICONE DE SAIR, ETC.
  final String title;

  //NUMERO DA PAGINA
  final int page;

  @override
  Widget build(BuildContext context) {

    final int curPage = context.watch<PageManager>().page; //OBTER A PAGINA ATUAL

    final Color primarycolor = Theme.of(context).primaryColor; //PASSAR A COR DO icone e texto da pagina selecionada
    return InkWell(

      //EFEITO DE CLIQUE
      onTap: (){

        context.read<PageManager>().setPage(page);
      },


      //USO O SIZEDBOX PARA DAR ESSE ESPAÇAMENTO DE ALTURA.
      child: SizedBox(
        height: 60,
        child: Row(
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.symmetric(horizontal:32), //ESPAÇAMENTO DE 32 HORIZONTAL E VERTICAL
              child: Icon(
                  iconData,  //PASSADO POR PARAMETRO
                size: 32 ,
                color: curPage == page? primarycolor:    Colors.grey[700],
              ),
            ),

            // const SizedBox(width: 32,),  MAS VOU USAR PADDING, ESPAÇAMENTO DE LARGURA ENTRE O BOTAO E O TEXTO


            Text(
              title, //PASSADO POR PARAMETRO
              style: TextStyle(
                fontSize: 16,
                color: curPage == page? primarycolor:   Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
