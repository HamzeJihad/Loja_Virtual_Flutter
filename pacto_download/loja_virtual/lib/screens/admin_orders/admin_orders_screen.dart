import 'package:flutter/material.dart';
import 'package:loja_virtual/componentescomuns/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/componentescomuns/custom_iconbuton.dart';
import 'package:loja_virtual/componentescomuns/empty_card.dart';
  import 'package:loja_virtual/modelos/admin_order_manager.dart';
import 'package:loja_virtual/modelos/order.dart';
import 'package:loja_virtual/screens/orders/components/order_tile.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


class AdminOrdersScreen extends StatefulWidget {

  @override
  _AdminOrdersScreenState createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text('Todos os Pedidos'),
        centerTitle: true,
      ),
      body: Consumer<AdminOrdersManager>(
          builder: (_, ordersManager, __){
              final filteredOrders = ordersManager.filteredOrders;

              return SlidingUpPanel(
                controller: panelController,
                 body:Column(
                   children: <Widget>[

                     //SE EU ESTIVER FILTRANDO PARA UM USUÁRIO, MOSTRO O NOME E BOTÃO PARA PARAR DE FILTRAR
                     if(ordersManager.userfilter != null)
                       Padding(
                         padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                         child: Row(
                           children: <Widget>[
                             Expanded(
                               child: Text(
                                 'Pedidos de ${ordersManager.userfilter.name}',
                                 style: TextStyle(
                                   fontWeight: FontWeight.w800,
                                   color: Colors.white,
                                 ),
                               ),
                             ),
                             CustomIconButton(
                               iconData: Icons.close,
                               color: Colors.white,
                               onTap: (){
                                 ordersManager.setUserFilter(null);
                               },
                             )
                           ],
                         ),
                       ),

                     if(filteredOrders.isEmpty)
                       Expanded(
                         child: EmptyCard(
                           title: 'Nenhuma venda realizada!',
                           iconData: Icons.border_clear,
                         ),
                       )

                     //caso contrário mostro a lista com todos os itens
                     else
                       Expanded(
                         child: ListView.builder(
                             itemCount: filteredOrders.length,
                             itemBuilder: (_, index){
                               return OrderTile(
                                 filteredOrders[index],
                                 showControls: true,
                               );
                             }
                         ),
                       ),
                     const SizedBox(height: 120,)

                   ],
                 ),

                //PAINEL
                minHeight: 40,
                maxHeight: 240,
                panel: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    GestureDetector(

                      //quando clicar, ira fechar ou abrir o filtro
                      onTap: (){
                        if(panelController.isPanelClosed){
                          panelController.open();
                        }
                        else{
                          panelController.close();
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        color: Colors.white,
                        child: Text(
                          'Filtros',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: Status.values.map((s) {

                          return CheckboxListTile(
                            title: Text(Order.getStatusText(s)),
                            dense: true,
                            activeColor: Theme.of(context).primaryColor,
                            value: ordersManager.statusFilter.contains(s),
                            onChanged: (v){
                                ordersManager.setStatusFilter(
                                  status: s,
                                  enabled: v,
                                );
                            },
                          );
                        }).toList() ,

                        ),
                      ),

                  ],
                ),
              );

          }
      ),
    );
  }
}
