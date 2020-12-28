import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/modelos/product.dart';

class ProductManager extends ChangeNotifier{

  ProductManager(){

    _loadAllProducts();
  }


  final Firestore firestore = Firestore.instance;

  //LISTA DE PRODUTO CHAMADA _allProducts
  List<Product> allProducts = [];

  String _search = '';

  String get search => _search;
  set search(String value){
    _search = value;
    notifyListeners();
  }


  //SABER SE ESTÁ PESDQUISANDO OU NAO
  List<Product>get filterProducts{
    final List<Product> filteredProducts= [];

    //SE ESTIVER VÁZIO , MOSTRO TODOS MEUS PRODUTOS
    if(search.isEmpty){

      filteredProducts.addAll(allProducts);
    }
    else{
      filteredProducts.addAll
        (allProducts.where((p) => p.name.toLowerCase().contains(search.toLowerCase())));
    }

  return filteredProducts;
  }

  Future<void> _loadAllProducts() async{

    //QUERYSNAPSHOT PEGA TODOS ELEMENTOS
    final  QuerySnapshot snapProducts  = await firestore.collection('products')
        .where('deleted', isEqualTo: false).getDocuments();

    //PEGAR CADA UM DOS DOCUMENTOS E TRANSFORMAR EM OBJETO E NO FIM EM UMA LISTA DE PRODUTOS
    allProducts = snapProducts.documents.map(
            (d) => Product.fromDocument(d)).toList();


    notifyListeners();
  }


  Product findProductById(String id){

    try{
    return allProducts.firstWhere((p) => p.id == id);
  }
  catch(e){
      return null;
  }
  }

//ATUALIZAR A TELA APÓS SALVAR, REMOVENDO OS ANTIGOS E COLOCANDO OS NOVOS
  void update(Product product){

    allProducts.removeWhere((p) => p.id == product.id); 
    allProducts.add(product);
    notifyListeners();
  }

  void delete(Product product){
    product.delete();
    allProducts.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }
}