
import 'package:flutter/material.dart';
import 'package:loja_virtual/componentescomuns/custom_iconbuton.dart';
import 'package:loja_virtual/modelos/store.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:map_launcher/map_launcher.dart';
//TODA TELA DAS LOJAS
class StoreCard extends StatelessWidget {

  const StoreCard(this.store);

  final Store store;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;


    Color colorForStatus(StoreStatus status){
      switch(status){
        case StoreStatus.closed:
          return Colors.red;
        case StoreStatus.open:
          return Colors.green;
        case StoreStatus.closing:
          return Colors.orange;
        default:
          return Colors.green;
      }
    }

    void showError(){
      Scaffold.of(context).showSnackBar(
          const SnackBar(
            content: Text('Esta função não está disponível neste dispositivo'),
            backgroundColor: Colors.red,
          )
      );
    }

    Future<void> openPhone() async {
      if(await canLaunch('tel:${store.cleanPhone}')){
        launch('tel:${store.cleanPhone}');
      } else {
        showError();
      }
    }

    Future<void > openMap() async {
      try {
        final availableMaps = await MapLauncher.installedMaps;

        showModalBottomSheet(
            context: context,
            builder: (_) {
              return SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for(final map in availableMaps)
                      ListTile(
                        onTap: (){
                          map.showMarker(
                            coords: Coords(store.address.lat, store.address.long),
                            title: store.name,
                            description: store.addressText,
                          );
                          Navigator.of(context).pop();
                        },
                        title: Text(map.mapName),
                        leading: Image(
                          image: map.icon,
                          width: 30,
                          height: 30,
                        ),
                      )
                  ],
                ),
              );
            }
        );
      } catch (e){
        showError();
      }
    }

    return Card(
      clipBehavior: Clip.antiAlias, //ARREDONDAMENTO DE CARD
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: <Widget>[

          //LOCAL DE FECHADO E ABERTO NAS LOJAS
          Container(
            height: 160,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.network(store.image,
                fit: BoxFit.cover,),

                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.all(8),

                     //COLOQUEI O BOXDECORATION PARA ARREDONDAR A BORDA ESQUERDA
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8)),
                    ),
                    child: Text(
                      store.statusText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: colorForStatus(store.status),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 140,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        store.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        store.addressText,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text(
                        store.openingText,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomIconButton(
                      iconData: Icons.map,
                      color: primaryColor,
                      onTap: openMap,
                    ),
                    CustomIconButton(
                      iconData: Icons.phone,
                      color: primaryColor,
                      onTap: openPhone,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }


}