import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'itens_size.dart';

class Product extends ChangeNotifier {

  Product({this.id, this.name, this.description, this.images, this.sizes,this.deleted = false}){
    images = images ?? [];
    sizes =  sizes ?? [];
  }


  Product.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    name = document['name'] as String;
    description = document['description'] as String;
    images = List<String>.from(document.data['images'] as List<dynamic>);
    deleted = (document.data['deleted'] ?? false) as bool;

    //SE NAO TIVER O  TAMANHO RETORNA LISTA VAZIA []
    sizes = (document.data['sizes'] as List<dynamic> ?? []).map(
            (s) => ItemSize.fromMap(s as Map<String, dynamic>)).toList();
    //COLOQUEI as Map<String> PORQUE NO ITENS_SIZE
    //DECLAREI COMO UMA LISTA
  }

  final Firestore firestore = Firestore.instance;
  final FirebaseStorage storage  = FirebaseStorage.instance;
  DocumentReference get firestoreRef => firestore.document('products/$id');

  //PASTA PRODUTOS E DENTRO CRIEI UMA PASTA COM O ID DO PRODUTO
  StorageReference get storageRef => storage.ref().child('products').child(id);

  String id;
  String name;
  String description;
  List<String> images;

  List<dynamic> newImages;

  bool deleted;

  bool _loading = false;
  bool get loading => _loading;

  set loading(bool value){

    _loading = value;
    notifyListeners();
  }

  //RESPONSÁVEL PELO ESTOQUE
  List<ItemSize> sizes;

  ItemSize _selectedSize;

  ItemSize get selectedSize => _selectedSize;

  set selectedSize(ItemSize value) {
    _selectedSize = value;
    notifyListeners();
  }


  //QUANTIDADE EM ESTOQUE
  int get totalStock {
    int stock = 0;
    for (final size in sizes) {
      stock += size.stock;
    }
    return stock;
  }


  bool get hasStock {
    return totalStock > 0 && !deleted;
  }


  //DESCOBRIR O TAMANHO DO ITEM NO CARRINHO
  ItemSize findSize(String name) {
    try {
      return sizes.firstWhere((s) => s.name == name);
    } catch(e){
      return null;
    }
  }

  //pegar cada um dos tamanhos
  List<Map<String, dynamic>> exportSizeList(){
    return sizes.map((size) => size.toMap()).toList();
  }

  Future<void> save() async {
    loading = true;
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'sizes': exportSizeList(),
      'deleted': deleted
    };

    if(id == null){
      final doc = await firestore.collection('products').add(data);
      id = doc.documentID;
    } else {
      await firestoreRef.updateData(data);
    }


    final List<String> updateImages = [];

  //IMAGENS
    for(final newImage in newImages){

      if(images.contains(newImage)) {
        updateImages.add(newImage as String);

      }
      else{
        //ACESSEI A PASTA DO MEU PRODUTO,  E CRIEI UM NOME ÚNICO
       final StorageUploadTask task =  storageRef.child(Uuid().v1()).putFile(newImage as File);
        final StorageTaskSnapshot snapshot = await task.onComplete;
        final String url = await snapshot.ref.getDownloadURL() as String;
        updateImages.add(url);

      }
  }

     //VERIFICAR SE AS IMAGENS AINDA EXISTEM
    for( final image in images){
      if(!newImages.contains(image) && image.contains('firebase')){
        try {
          final ref = await storage.getReferenceFromUrl(image);
          await ref.delete();
        }catch(e){
          debugPrint('Falha ao deletar: $image');
        }
      }
    }
    
    await firestoreRef.updateData({'images': updateImages});
    images = updateImages;

    loading = false;

  }
  void delete(){
    firestoreRef.updateData({'deleted': true});
  }

  //CLONAR TODOS OS PRODUTOS
  Product clone(){
    return Product(
      id: id,
      name: name,
      description: description,
      images: List.from(images),
      sizes: sizes.map((size) => size.clone()).toList(),
      deleted: deleted,

    );
  }


  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, images: $images, newImages: $newImages, sizes: $sizes}';
  } //encontrar o menor valor de preço entre os nossos produtos


num get basePrice{
    num lowest= double.infinity;
    for(final size in sizes){
      if(size.price < lowest)
        lowest = size.price;
    }
    return lowest;
}
}