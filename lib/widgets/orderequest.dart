import 'package:flutter/material.dart';
import 'package:mashghal_co/providers/Auth.dart';
import 'package:provider/provider.dart';
import '../models/orderModel.dart';

class OrderRequest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(Provider.of<Auth>(context).token);
    final service = Provider.of<Services>(context).userService;
    final day = Provider.of<Services>(context).day;
    final hours = Provider.of<Services>(context).hours;
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 6.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                service.type,
                style: TextStyle(
                  color: Color.fromRGBO(104, 57, 120, 10),
                  fontSize: 20.0,
                  fontFamily: 'beINNormal',
                ),
              ),
              SizedBox(
                width: 25.0,
              ),
              Image.asset(
                'assets/icons/funds.png',
                fit: BoxFit.cover,
                color: Color.fromRGBO(104, 57, 120, 10),
              ),
              SizedBox(
                width: 10.0,
              ),
              service.status == 0
                  ? Text(
                      service.price,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18.0,
                        fontFamily: 'beINNormal',
                      ),
                    )
                  : Text(
                      service.offer,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18.0,
                        fontFamily: 'beINNormal',
                      ),
                    ),
            ],
          ),
          //--------------------------------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.calendar_today,
                color: Color.fromRGBO(104, 57, 120, 10),
                size: 20.0,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                '${day}day',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18.0,
                  fontFamily: 'beINNormal',
                ),
              ),
            ],
          ),
          //--------------------------------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.alarm,
                color: Color.fromRGBO(104, 57, 120, 10),
                size: 20.0,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                '${hours}:00',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18.0,
                  fontFamily: 'beINNormal',
                ),
              ),
            ],
          ),
          //--------------------------------------------------------------------
          Container(
            color: Colors.grey[200],
            height: 1.0,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
