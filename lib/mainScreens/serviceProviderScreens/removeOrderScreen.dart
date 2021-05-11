import 'package:flutter/material.dart';
import 'package:mashghal_co/widgets/orderequest.dart';
import 'package:provider/provider.dart';
import '../../providers/ordersProvider.dart';
import '../../models/orderModel.dart';

class RemovingOrderScreen extends StatelessWidget {
  // variable to ref screen name to routes in main.dart and Navigation
  static const routeName = 'removeOrderScreen';
  final int orderId;
  final String userImage;
  final List<Services> services;

  RemovingOrderScreen({this.userImage, this.orderId, this.services});

  //-------------------------------methods--------------------------------------
  Future<void> _delete(BuildContext context) async {
    await Provider.of<OrdersProvider>(context).delete(orderId);
    Navigator.of(context).pop();
    await Provider.of<OrdersProvider>(context, listen: false)
        .fetchAdvertiserInitOrders(DateTime.now());
  }

  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(235, 218, 241, 10),
          title: Text(
            'بيانات الطلب',
            style: TextStyle(
              color: Color.fromRGBO(104, 57, 120, 10),
              fontSize: 20.0,
              fontFamily: 'beINNormal',
            ),
          ),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Color.fromRGBO(104, 57, 120, 10),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<OrdersProvider>(context, listen: false)
                    .fetchAdvertiserInitOrders(DateTime.now());
              }),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30.0,
              horizontal: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 25.0,
                    horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(5.0, 5.0),
                        blurRadius: 20.0,
                        spreadRadius: 3.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Spacer(),
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 50,
                            backgroundImage: NetworkImage(
                                'https://mashghllkw.com/cdn/' + userImage),
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      //--------------------------------------------------------
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: double.infinity,
                        child: ListView.builder(
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            return ChangeNotifierProvider(
                              create: (context) => services[index],
                              child: OrderRequest(),
                            );
                          },
                        ),
                      ),
                      //--------------------------------------------------------
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => _delete(context),
                      child: Container(
                        width: 150,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(104, 57, 120, 10),
                          borderRadius: BorderRadius.circular(
                            8.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'حذف',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontFamily: 'beINNormal',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
