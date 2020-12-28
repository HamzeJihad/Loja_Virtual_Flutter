import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:loja_virtual/helpers/validators.dart';
import 'package:loja_virtual/modelos/user.dart';
import 'package:loja_virtual/modelos/user_manager.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      key: scaffoldkey,
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,

        //CADASTRO DE USUARIO
        actions: <Widget>[
          FlatButton(
              onPressed:(){
                Navigator.of(context).pushReplacementNamed('/signup');
              },

              textColor: Colors.white,
              child: const Text('CRIAR CONTA',
              style: TextStyle(fontSize: 16),
              ),
          ),
        ],
      ),

      //CAMPOS DE EMAIL, LOGIN E SENHA
      body: Center(
        child: Card(

          //ESPACAMENTO DAS LATERAIS
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formkey ,
            child: Consumer<UserManager>(
              builder: (_, userManager, __){

                if(userManager.loadingFace){
                  return Padding(
                    padding: const EdgeInsets.all(16.0 ),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  //OCUPAR A MENOR ALTURA POSSIVEL
                  shrinkWrap: true,
                  children: <Widget>[

                    //CAMPO DE EMAIL
                    TextFormField(
                      controller: emailController,
                      enabled: !userManager.loading ,
                      decoration: InputDecoration(hintText: 'Email'),

                      keyboardType: TextInputType.emailAddress, //OPCÃO DE COLOCAR O @
                      textInputAction: TextInputAction.next,
                      //NAO FICAR TRANSFORMANDO PARA MAIUSCULO NA HORA QUE TIVER DIGITANDO
                      autocorrect: false,

                      //VALIDAÇÃO DO EMAIL
                      validator: (email){
                        if(!emailValid(email))
                          return 'Email Invalido';
                        return null;
                      },
                    ),

                    //ESPACAMENTO ENTRE SEMAIL E SENHA
                    const SizedBox(height: 16,),

                    //CAMPO DE SENHA
                    TextFormField(
                      controller: passController,
                 enabled: !userManager.loading,
                decoration: InputDecoration(hintText: 'Senha'),

                      //NAO FICAR TRANSFORMANDO PARA MAIUSCULO NA HORA QUE TIVER DIGITANDO
                      autocorrect: false,
                      obscureText: true, //PARA NAO APARECER A SENHA
                      validator: (pass){
                        if(pass.isEmpty || pass.length < 6)
                          return 'Senha Invalida';

                        return null;
                      },

                    ),


                    //CAMPO ESQUECEU SENHA
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: (){

                        },
                        padding: EdgeInsets.zero,
                        child: const  Text('Esqueci minha senha',

                        ),
                      ),
                    ),

                    //ESPACAMENTO ENTRE SENHA E ENTRAR
                    const SizedBox(height: 16,),

                    //BOTAO DE ENTRAR
                    RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onPressed: userManager.loading ? null :   (){

                        //SE FOR VALIDO
                        if( formkey.currentState.validate()){

                          context.read<UserManager>().signIn(

                            user: User(
                              email: emailController.text,
                              password: passController.text,
                            ),
                            onFail: (e){
                              scaffoldkey.currentState.showSnackBar(

                                //ERRO AO ENTRAR
                                SnackBar(
                                  content: Text('Falha Ao Entrar: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                            onSucess:  (){
                              Navigator.of(context).pop();
                            },
                          );

                        }
                      },

                      color: Theme.of(context).primaryColor,
                      disabledColor: Theme.of(context).primaryColor.withAlpha(100),
                      textColor: Colors.white,

                      //SE ESTIVER CARREGANDO
                      child: userManager.loading?
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ):
                      const Text('Entrar',
                        style: TextStyle(fontSize: 15),),
                    ),
                    SignInButton(
                        Buttons.Facebook,
                        text: 'Entrar com Facebook',
                        onPressed: (){
                          userManager.facebookLogin(
                              onFail: (e){
                                scaffoldkey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text('Falha ao entrar: $e'),
                                      backgroundColor: Colors.red,
                                    )
                                );
                              },
                              onSuccess: (){
                                Navigator.of(context).pop();
                              }
                          );
                        },
                    )
                  ],

                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
