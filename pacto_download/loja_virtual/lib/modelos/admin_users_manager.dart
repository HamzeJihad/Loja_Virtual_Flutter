import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/modelos/user.dart';
import 'package:loja_virtual/modelos/user_manager.dart';


//BUSCAR TODOS OS USUÁRIOS NO FIREBASE
class AdminUsersManager extends ChangeNotifier{


  List<User> users = [];
  final Firestore firestore = Firestore.instance;

  void updateUser(UserManager userManager){

    //EU TENHO UM USUÁRIO E ELE É ADMINISTRADOR
    if(userManager.adminEnabled){
      _listenToUsers();
    }
    else{
      users.clear();
      notifyListeners();
    }
  }

  void _listenToUsers(){

    //BUSCANDO OS USUARIOS NO FIREBASE
    firestore.collection('users').getDocuments().then((snapshot) {
      users = snapshot.documents.map((e) => User.fromDocument(e)).toList();
      //ORDENANDO A LISTA EM ONTEM ALFABETICA
      users.sort((a,b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      notifyListeners();
    });

  }


  //PEGUEI CADA UM DOS USUÁRIOS, PEGUEI O NOME DELES E ADICIONEI NA MINHA LISTA
  List<String> get names => users.map((e) => e.name).toList();
}

