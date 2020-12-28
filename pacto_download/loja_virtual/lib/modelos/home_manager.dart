

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/modelos/section.dart';

class HomeManager extends ChangeNotifier{

  HomeManager(){
    _loadSections(); //CARREGAR TODAS AS SEÇÕES DO NOSSO APP
  }

  final Firestore firestore = Firestore.instance;
  //BUSCAR TODAS AS SESSÕES DO FIREBASE,


  final List<Section> _sections = [];


  List<Section> _editingSections =[];

//MODO DE EDIÇÃO OU NÃO
  bool editing = false;


  bool loading = false;


  Future<void> _loadSections() async{

    firestore.collection('home').orderBy('pos').snapshots().listen((snapshot) {

      _sections.clear();
      //PARA CADA UM DOS DOCUMENTOS QUE EU BUSQUEI NA HOME, VOU TRANSFORMAR EM UM OBJETO-PRODUTO
      for(final DocumentSnapshot document in snapshot.documents){
        _sections.add(Section.fromDocument(document));
      }
      notifyListeners();
    });
  }

  List<Section> get sections {
    if(editing)
      return _editingSections;

    else
      return _sections;
  }

void addSection(Section section){
    _editingSections.add(section);
    notifyListeners();
}

void removeSection(Section section){
    _editingSections.remove(section);
    notifyListeners();
}

//QUANDO QUEREMOS ENTRAR NO MODO DE EDIÇÃO
  void enterEditing(){

    editing = true;
    _editingSections = _sections.map((s) => s.clone()).toList();
    notifyListeners();
  }


  //SALVAR EDIÇÃO DA HOME
  void saveEditing() async{
    bool valid = true;
    for(final section in _editingSections){
      if(!section.valid()) valid = false;
    }

    if(!valid) return;

    loading = true;
    notifyListeners();

    int pos = 0;

    for(final section in _editingSections){
      await section.save(pos);
      pos++;
    }

    /*PARA CADA SESSÃO NAS MINHAS SESSÕES ANTES DO SALVAMENTO, IREI VERIFICAR
    SE ESSA SESSÃO EXISTE MAIS*/
    for(final section in List.from(_sections)){

      if(!_editingSections.any((element) => element.id == section.id)){

        await section.delete();
      }
    }

    loading = false;
    editing = false;
    notifyListeners();
  }


  void discardEditing(){

    editing = false;
    notifyListeners();
  }
}
