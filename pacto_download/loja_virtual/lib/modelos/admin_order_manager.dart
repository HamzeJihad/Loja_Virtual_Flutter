import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/modelos/order.dart';
import 'package:loja_virtual/modelos/user.dart';


class AdminOrdersManager extends ChangeNotifier{



 final List<Order> _orders = [];

  User userfilter;

  List<Status> statusFilter = [Status.preparing];



  final Firestore firestore   = Firestore.instance;
  StreamSubscription _subscription;

  void updateAdmin(bool adminEnabled){

    _orders.clear();

    _subscription?.cancel();
    if(adminEnabled){
      _listenToOrders();
    }
  }

  List<Order> get filteredOrders{
    List<Order> output = _orders.reversed.toList();

    if(userfilter != null){
      output  = output.where((o) => o.userId == userfilter.id).toList();
    } 
    
    return  output.where((o) => statusFilter.contains(o.status)).toList();

  }

  void _listenToOrders(){

    _subscription = firestore.collection('orders').snapshots().listen(
            (event) {
      for (final change in event.documentChanges){

            switch(change.type){

              case DocumentChangeType.added:
                _orders.add(

                 Order.fromDocument(change.document)
                );
                break;

              case DocumentChangeType.modified:
                  final modOrder = _orders.firstWhere((o) =>
                  o.orderId == change.document.documentID);
                  modOrder.updateFromDocument(change.document);
                break;

              case DocumentChangeType.removed:
                debugPrint('Apagou do firebase, não pode ocorrer, admin_order_manager');
                break;
            }

              }


      notifyListeners();
    });
  }


  void setUserFilter(User user){
    userfilter = user;
    notifyListeners();
  }


  //HABILITAR OS FILTROS
  void setStatusFilter({Status status, bool enabled}){
    if(enabled){
      statusFilter.add(status);
    }
    else{
      statusFilter.remove(status);
    }
    notifyListeners();
  }

  @override
  void dispose(){
    super.dispose();
    _subscription?.cancel();
  }

}