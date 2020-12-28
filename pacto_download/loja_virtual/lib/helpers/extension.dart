

import 'package:flutter/material.dart';

extension Extra on TimeOfDay {

  String formatted(){

    //quero que tenha 2 caracteres e caso não tenha, insira 0
    return '${hour}h${minute.toString().padLeft(2, '0')}';
  }


  int toMinutes() => hour*60 + minute;

}