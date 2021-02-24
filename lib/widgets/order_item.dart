import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:online_shop/models/order_item.dart';
import 'package:online_shop/widgets/cart_item.dart';
import 'package:online_shop/widgets/product_item.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem _orderItem;

  OrderItemWidget(this._orderItem);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget._orderItem.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy-hh:mm')
                .format(widget._orderItem.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          _expanded
              ? Container(
            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 30),
            height: min(
                widget._orderItem.products.length * 20.0 + 10, 180.0),
            child: ListView.builder(
                itemCount: widget._orderItem.products.length,
                itemBuilder: (_, i) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget._orderItem.products[i].title,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Text('${widget._orderItem.products[i].quantity}x   \$${widget
                              ._orderItem.products[i].price}',
                        style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),)
                    ],
                  );
                }),
          )
              : Container(),
        ],
      ),
    );
  }
}
