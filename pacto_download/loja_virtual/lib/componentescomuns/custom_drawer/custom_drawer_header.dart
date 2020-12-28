import 'package:flutter/material.dart';
import 'package:loja_virtual/modelos/page_manager.dart';
import 'package:loja_virtual/modelos/user_manager.dart';
import 'package:provider/provider.dart';


//OPCÕES DE LOJA DO HAMZE, LOGAR E SAIR.
class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 24, 16, 8),
      height: 180,

      child: Consumer<UserManager>(
        builder: (_, userManager, __){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Loja da\nPacto',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),


              Text(
                'Olá, ${userManager.user?.name ?? ''}',
                overflow: TextOverflow.ellipsis, //EVITAR QUE O NOME SAIA DA TELA
                maxLines: 2,
                style: TextStyle(fontSize: 18,
                fontWeight: FontWeight.bold),

              ),


              //BOTAO DE SAIR OU LOGAR
              GestureDetector(
                onTap: (){

                  //SE ESTIVER LOGADO VOU SIR
                  if(userManager.isLoggedIn){


                    context.read<PageManager>().setPage(0); //SEMPRE QUE TROCAR DE USUARIO VAI MANDAR PARA TELA 0
                    userManager.signOut();
                  }

                  else{
                    Navigator.of(context).pushNamed('/login');
                  }
                },
                child: Text(

                  userManager.isLoggedIn ? 'Sair':
                      'Entre ou Cadastre-se > ',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
