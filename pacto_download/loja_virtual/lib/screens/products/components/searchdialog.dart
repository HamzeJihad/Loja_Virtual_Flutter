import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {

  const SearchDialog(this.initialText);

  //PARA NAO APAGAR O TEXTO QUANDO FOR EDITAR A PESQUISA
  final String initialText;

  @override
  Widget build(BuildContext context) {

    //CAMPO DE PESQUISA
    return Stack(
      children: <Widget>[
        
        Positioned(
            top: 2,
            left: 4 ,
            right: 4,
        child: Card(
          child: TextFormField(
            initialValue: initialText,

            //ICONE DE PESQUISA NO TECLADO DO CELULAR
            textInputAction: TextInputAction.search,

            //QUANDO CLICAR NO ICONE DE PESQUISA AUTOMATICAMENTE JÁ ABRE O TECLADO
            autofocus: true,


            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),

              //BOTAO PARA SAIR DA PESQUISA
                prefixIcon: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    //VOLTAR
                     Navigator.of(context).pop();
                  },
              )
            ),

            //ME PASSA O TEXTO QUE DIGITEI
            onFieldSubmitted: (text){
              Navigator.of(context).pop(text);
            },
          ),

        ),)
      ],
    );
  }
}
