import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/modelos/itens_size.dart';
import 'package:loja_virtual/modelos/product.dart';

class CartProduct extends ChangeNotifier{

  //VAI RECEBER UM PRODUTO  NA LOJA E TRANSFORMAR EM UM PRODUTO NO CARRINHO
 CartProduct.fromProduct(this._product){

   productId= product.id;
   quantity = 1;
   size = product.selectedSize.name;
 }

 CartProduct.fromDocument(DocumentSnapshot document){
   id = document.documentID;
   productId = document.data['pid'] as String;
   quantity = document.data['quantity'] as int;
   size = document.data['size'] as String;

   firestore.document('products/$productId').get().then(
           (doc) {
             product =Product.fromDocument(doc);

           }
   );

 }

 CartProduct.fromMap(Map<String,dynamic> map){
    productId = map['pid'] as String;
    quantity = map['quantity'] as int;
    size = map['size'] as String;
    fixedPrice = map['fixePrice'] as num;
    firestore.document('products/$productId').get().then(
            (doc) {
          product =Product.fromDocument(doc);

        }
    );
 }

 final Firestore firestore = Firestore.instance;


 String id;

 String productId;
 int quantity;
 String size;

 num fixedPrice;

 Product _product;

 Product get product => _product;
 set product(Product value){
   _product = value;
   notifyListeners();
 }

 ItemSize get  itemSize{
   if(product == null) return null;

   return  product.findSize(size);
 }

 //ENCONTRAR O PREÇO UNITÁRIO DESSE TAMANHO
  num get unitPrice{

   if(product == null) return 0;
   return itemSize?.price ?? 0;
 }


 //PREÇO TOTAL DOS ITENS DO CARRINHO
 num get totalPrice => unitPrice * quantity;

 Map<String,dynamic> toCartItemMap(){

   return {
     'pid' : productId,
     'quantity': quantity,
      'size': size,
   };
 }

 Map<String,dynamic> toOrderItemMap(){

   return {
     'pid' : productId,
     'quantity': quantity,
     'size': size,
     'fixedPrice': fixedPrice ?? unitPrice,
   };
 }




 //SABER SE OS PRODUTOS SAO IGUAIS PARA EMPILHAR

 bool stackable(Product product){

   return product.id == productId && product.selectedSize.name == size;
 }

 void increment(){

   quantity++;
   notifyListeners();
 }

 void decrement(){
   quantity--;
   notifyListeners();
 }


 //CONTROLE  DE ESTOQUE
 bool get hasStock{
   if(product != null && product.deleted) return false;
   final size  = itemSize;
   if(product != null && product.deleted) return false; //nao tem estoque

   return  size.stock >= quantity;

 }
}