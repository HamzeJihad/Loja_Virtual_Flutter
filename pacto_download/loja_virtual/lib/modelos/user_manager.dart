import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:loja_virtual/helpers/firebase_error.dart';
import 'package:loja_virtual/modelos/user.dart';

class UserManager extends ChangeNotifier{

  UserManager(){

    _loadCurrentUser();

  }

  //NAO PRECISAR FICAR COPIANDO FIREBASE.AUTH
  final FirebaseAuth auth = FirebaseAuth.instance;

  final Firestore firestore = Firestore.instance;

  //USUÁRIO ATUAL
  User user;

  //CARREGAMENTO DA TELA
  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  bool _loadingFace = false;
  bool get loadingFace => _loadingFace;
  set loadingFace(bool value){
    _loadingFace = value;
    notifyListeners();
  }


  bool get isLoggedIn => user != null;  //SE O USUARIO ESTA LOGADO

  Future<void> signIn({User user, Function onFail, Function onSucess}) async{

    //QUANDO COMEÇARMOS O  login estará carregando
    loading= true;
  try {
    final AuthResult result = await auth.signInWithEmailAndPassword(
        email: user.email, password: user.password);

    _loadCurrentUser(firebaseUser: result.user);

   onSucess();

  }
   on PlatformException catch(e){
        onFail(getErrorString(e.code));
  }
  //QUANDO TERMINAR
  loading = false;

  }

  Future<void> facebookLogin({Function onFail, Function onSuccess}) async {
    loadingFace = true;

    final result = await FacebookLogin().logIn(['email', 'public_profile']);

    switch(result.status){
      case FacebookLoginStatus.loggedIn:
        final credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token
        );

        final authResult = await auth.signInWithCredential(credential);

        if(authResult.user != null){
          final firebaseUser = authResult.user;

          user = User(
              id: firebaseUser.uid,
              name: firebaseUser.displayName,
              email: firebaseUser.email
          );

          await user.saveData();

          onSuccess();
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        onFail(result.errorMessage);
        break;
    }

    loadingFace = false;
  }

  Future<void> signUp({User user, Function onFail, Function onSuccess})async {
    loading = true;
    try{
      final AuthResult result = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      user.id = result.user.uid;

      this.user = user;
      await user.saveData();


    onSuccess();
    } on PlatformException catch (e){
    onFail(getErrorString(e.code));
    }
    loading = false;
  }

  void signOut(){
    auth.signOut();
    user = null;
    //loadingFace = false;

    notifyListeners();


  }


  void _loadCurrentUser({FirebaseUser firebaseUser}) async {

   final  FirebaseUser currentUser =  firebaseUser ?? await auth.currentUser();
    if(currentUser != null){
      final DocumentSnapshot docUser = await  firestore.collection('users')
          .document(currentUser.uid).get();
    
      user =   User.fromDocument(docUser); //AQUI TENHO MEU USUARIO


      final docAdmin = await firestore.collection('admins').document(user.id).get();

      if(docAdmin.exists){
        user.admin = true;

      }
      notifyListeners();

    }
  }

  //USUÁRIO ADMINISTRADOR OU NÃO
  bool get adminEnabled => user != null && user.admin;
}