import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loja_virtual/modelos/address.dart';
import 'package:loja_virtual/modelos/card_product.dart';
import 'package:loja_virtual/modelos/product.dart';
import 'package:loja_virtual/modelos/user.dart';
import 'package:loja_virtual/modelos/user_manager.dart';
import 'package:loja_virtual/services-api/cepaberto_service.dart';

class CartManager extends ChangeNotifier{

  //todos os produtos do carrinho
  List<CartProduct> items = [];

  User user;
  Address address;
  num productPrice  = 0.0;
  num deliveryPrice;
                                        //SE O DELIVERYPRICE FOR NULO IRÁ SOMAR 0
  num get totalPrice  => productPrice + (deliveryPrice ?? 0);

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
      _loading = value;
      notifyListeners();

  }

  final Firestore firestore = Firestore.instance;

  void updateUser(UserManager userManager){

    user = userManager.user;
    productPrice = 0.0;
    items.clear(); //APAGAR OS ITENS DO CARRINHO
    removeAddress();
    if(user != null){
      _loadCartItems();
      _loadUserAddress() ;//verificar se o usuário já tem o endereço configurado;
    }
  }


  //VAI ACESSAR A SUB-COLEÇÃO DO CARRINHO DO USUÁRIO
  Future<void>  _loadCartItems () async{

    final QuerySnapshot cartSnap = await user.cartReference.getDocuments();

    //JÁ E NOTIFICADO CASO O PRODUTO VENHA DO FIREBASE
  items =   cartSnap.documents.map((d) => CartProduct.fromDocument(d)..addListener(_onItemUpdated)
  ).toList();

  }


  Future<void> _loadUserAddress ()async{

    if(user.address != null && await calculateDelivery(user.address.lat, user.address.long)){

      address = user.address;
      notifyListeners();
    }
  }
  //ADICIONAR PARA O CARRINHO
  void addToCart(Product product){

    try {
      //PROCURAR SE TEM UM ITEM JA ADICIONADO IGUAL, PARA CASO ADICIONAR 2P, 2M, ETC.
      final e = items.firstWhere((p) =>
          p.stackable(product)); //STACKBLE VAI SER UMA FUNCAO PARA EU SABER
      //SE O PRODUTO É IGUAL OU NÃO
      e.increment();
    }
    catch(e){
      //PEGUEI O PRODUTO E ADICIONEI A UM PRODUTO QUE PODE IR NO CARRINHO E ADICIONEI AO CARRINHO
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdated);
      items.add(cartProduct);
      user.cartReference.add(cartProduct.toCartItemMap()).then((doc) =>  cartProduct.id = doc.documentID);
      _onItemUpdated();
    }
   notifyListeners();
  }

  void clear(){
    for(final cartProduct in items){
      user.cartReference.document(cartProduct.id).delete();
    }
    items.clear();
    notifyListeners();
  }

  //SOMAR O PREÇO TOTAL DOS PRODUTOS NO CARRINHO
  void _onItemUpdated(){

    productPrice = 0.0;
    for(int i = 0; i < items.length ; i ++){
      final cartProduct = items[i];
      if(cartProduct.quantity == 0){
        removeOfCart(cartProduct);
        i--;
        continue;
      }

      productPrice += cartProduct.totalPrice;
      _updateCartProduct(cartProduct);
    }

    notifyListeners();

  }


  //REMOVER O PRODUTO DO CARRINHO SE CHEGAR A 0
void removeOfCart(CartProduct cartProduct){

    items.removeWhere((produto) => produto.id == cartProduct.id);
    user.cartReference.document(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated);
    notifyListeners();
}

  //ATUALIZAÇÃO NO FIREBASE
  void  _updateCartProduct(CartProduct cartProduct){
    if(cartProduct.id != null)
    user.cartReference.document(cartProduct.id)
        .updateData(cartProduct.toCartItemMap());

  }


  //VERIFICAR SE O CARRINHO É VALIDO OU NAO
  bool get isCartValid{

    for(final cartProduct in items){

      if(!cartProduct.hasStock)return false;


    }
    return true;

  }


  bool get isAddressValid => address != null && deliveryPrice != null;

  //ENDEREÇO

Future<void> getAddress(String cep)async {

    loading = true;
    final cepAbertoService = CepAbertoService();

    try{

      //caso queira trocar a api, basta substituir essa parte
    final cepabertoaddress = await cepAbertoService.getAddressFromCep(cep);

    if(cepabertoaddress != null){
      address = Address(

        street: cepabertoaddress.logradouro,
        district: cepabertoaddress.bairro,
        zipCode: cepabertoaddress.cep,
        city: cepabertoaddress.cidade.nome,
        state: cepabertoaddress.estado.sigla,
        lat: cepabertoaddress.latitude,
        long: cepabertoaddress.longitude,

      );
    }
    loading = false;

    } catch(e){
      loading = false;

      return Future.error('CEP Inválido');
    }
  }



  //calcular taxa
  Future<void> setAddress(Address address) async{

  loading = true;
    this.address = address;

    if(await calculateDelivery(address.lat, address.long)){
      user.setAddress(address); //deixar o endereço salvo
      loading = false;
    }
    else{
      loading = false;
      return Future.error('Endereço fora do raio de entrega :(');
    }

  }

  //VAI CALCULAR A DISTANCIA

  Future<bool> calculateDelivery(double lat, double long)async{
    final DocumentSnapshot doc = await firestore.document('aux/delivery').get();

    final latStore = doc.data['lat'] as double;
    final longStore = doc.data['long'] as double;
    final base = doc.data['base'] as num;
    final km = doc.data['km'] as num;
    final maxKm = doc.data['maxkm'] as num;

   double dis = await  Geolocator().distanceBetween(latStore, longStore, lat, long);
    (dis/=1000.0);

    if(dis > maxKm){
      return false;
    }
    deliveryPrice = (base + dis*km);

    return true;
  }

  void removeAddress(){
    deliveryPrice= null;
    address = null;
    notifyListeners();
  }
}