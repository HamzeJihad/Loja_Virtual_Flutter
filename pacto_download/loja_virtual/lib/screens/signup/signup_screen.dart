import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/validators.dart';
import 'package:loja_virtual/modelos/user.dart';
import 'package:loja_virtual/modelos/user_manager.dart';
import 'package:provider/provider.dart';

//tela de cadastro
class SignUpScreen extends StatelessWidget {

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final User user = User();


  //para usar a snackbar
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(

        title: const Text('Criar Conta'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formkey,
            child: Consumer<UserManager>(
              builder: (_, userManager, __){

                return ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true, //OCUPAR O MENOR ESPAÇO POSSÍVEL
                  children: <Widget>[

                    //CAMPOS DE CADASTRO
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Nome Completo'),
                      enabled: !userManager.loading,

                      validator: (name){
                        if(name.isEmpty)
                          return 'Campo Obrigatório';

                        else if(name.trim().split(' ').length <= 1)
                          return 'Preencha Seu Nome Completo';

                        return  null;
                      },
                      textInputAction: TextInputAction.next,

                      onSaved: (name) => user.name   = name,
                    ),

                    const SizedBox(height: 16,),

                    TextFormField(
                      decoration: const InputDecoration(hintText: 'E-mail'),
                      enabled: !userManager.loading,
                      keyboardType: TextInputType.emailAddress, //OPCÃO DE COLOCAR O @
                      textInputAction: TextInputAction.next,
                      //NAO FICAR TRANSFORMANDO PARA MAIUSCULO NA HORA QUE TIVER DIGITANDO
                      autocorrect: false,
                      validator: (email){
                        if(email.isEmpty){
                          return 'Campo Obrigatório';
                        }
                        else if(!emailValid(email)){
                          return 'Email Inválido';
                        }
                        else {
                          return null;
                        }
                      },
                      onSaved: (email) => user.email = email,
                    ),

                    const SizedBox(height: 16,),

                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Senha'),
                      enabled: !userManager.loading,
                      //NAO FICAR TRANSFORMANDO PARA MAIUSCULO NA HORA QUE TIVER DIGITANDO
                      autocorrect: false,
                      obscureText: true, //PARA NAO APARECER A SENHA

                      validator: (pass){
                        if(pass.isEmpty){
                          return 'Campo Obrigatório';
                        }

                        else if(pass.length < 6){
                          return 'Senha Muito Curta';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,

                      onSaved: (pass) => user.password = pass,
                    ),

                    const SizedBox(height: 16,),

                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Repita a Senha'),
                      enabled: !userManager.loading,
                      //NAO FICAR TRANSFORMANDO PARA MAIUSCULO NA HORA QUE TIVER DIGITANDO
                      autocorrect: false,
                      obscureText: true,//PARA NAO APARECER A SENHA
                      validator: (pass){
                        if(pass.isEmpty){
                          return 'Campo Obrigatório';
                        }

                        else if(pass.length < 6){
                          return 'Senha Muito Curta';
                        }
                        return null;
                      },

                      onSaved: (pass) => user.confirmPassword = pass,

                    ),

                    const SizedBox(height: 16,),

                    //BOTÃO DE CADASTRO
                    RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap ,
                      color: Theme.of(context).primaryColor,
                      disabledColor: Theme.of(context).primaryColor.withAlpha(100),
                      textColor: Colors.white,
                      onPressed: userManager.loading ? null: (){

                        if(formkey.currentState.validate()){

                          formkey.currentState.save();


                          //SENHAS DIFERENTES
                          if(user.password  != user.confirmPassword){

                            scaffoldkey.currentState.showSnackBar(
                              SnackBar(
                                content: const Text('Senhas Diferentes'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }


                          //SUCESSO E ERRO DE CADASTRO
                          userManager.signUp(
                            user: user,
                            onSuccess: (){

                              Navigator.of(context).pop();
                            },
                            onFail: (e){

                              scaffoldkey.currentState.showSnackBar(

                                //ERRO AO ENTRAR
                                SnackBar(
                                  content: Text('Falha Ao Cadastrar: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                          );
                        }
                      },

                      child: userManager.loading ?
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                      : const Text(
                        'Criar Conta',
                        style: TextStyle(fontSize: 15),),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      )
    );
  }
}
