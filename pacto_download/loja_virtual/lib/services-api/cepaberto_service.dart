
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:loja_virtual/modelos/cepaberto_adress.dart';

const token = '15a54e81c57253223caf7ffe8ba5837b';


class CepAbertoService{

  Future<CepAbertoAddress> getAddressFromCep(String cep) async{

      final cleancep = cep.replaceAll('.', '').replaceAll('-', '');

      //ponto final
      final endpoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleancep";

      final Dio dio =  Dio();

      dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';


      try{

        final response = await dio.get<Map<String,dynamic>>(endpoint);

        if(response.data.isEmpty){
          return Future.error('Cep Inválido');
        }

        final CepAbertoAddress address = CepAbertoAddress.fromMap(response.data);

        return address;
      }
      on DioError catch(e){

            return Future.error('Erro ao buscar CEP');
      }

  }
}