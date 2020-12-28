import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/componentescomuns/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/modelos/admin_order_manager.dart';
import 'package:loja_virtual/modelos/admin_users_manager.dart';
import 'package:loja_virtual/modelos/page_manager.dart';
import 'package:provider/provider.dart';


//EXIBINDO TODOS OS USUÁRIOS PARA O ADMINISTRADOR
class AdminUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text("Usuários"),
        centerTitle: true,
      ),
      //SELECIONAR POR PRIMEIRA LETRA DO NOME
      body: Consumer<AdminUsersManager>(
        builder: (_, adminUsersManager,__){

          return AlphabetListScrollView(

            itemBuilder: (_, index){
                return ListTile(
                  title: Text(
                    adminUsersManager.users[index].name,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    adminUsersManager.users[index].email,
                    style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    ),
                  ),

                  //QUANDO CLICAR EM USUÁRIOS, IR PARA OS PEDIDOS DO USUÁRIO
                  onTap: (){
                    context.read<AdminOrdersManager>().setUserFilter(
                      adminUsersManager.users[index]
                    );
                    context.read<PageManager>().setPage(5);
                  },
                );
            },
            highlightTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20, 
            ),
            indexedHeight: (index)=> 80,
            strList: adminUsersManager.names,
            showPreview: true,
          );
        }
      )
    );
  }
}
