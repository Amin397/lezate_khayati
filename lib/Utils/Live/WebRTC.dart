

import 'dart:core';
import 'package:flutter/material.dart';
import 'package:lezate_khayati/Utils/Live/route_item.dart';

import 'loopback_sample.dart';

class Webrtc2 extends StatefulWidget {
  @override
  _Webrtc2State createState() => new _Webrtc2State();
}

class _Webrtc2State extends State<Webrtc2> {
  late List<RouteItem> items;

  @override
  initState() {
    super.initState();
    _initItems();
  }

  _buildRow(context, item) {
    return ListBody(children: <Widget>[
      ListTile(
        title: Text(item.title),
        onTap: () => item.push(context),
        trailing: Icon(Icons.arrow_right),
      ),
      Divider()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Flutter-WebRTC example'),
          ),
          body: new ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0.0),
              itemCount: items.length,
              itemBuilder: (context, i) {
                return _buildRow(context, items[i]);
              })),
    );
  }

  _initItems() {
    items = <RouteItem>[
      RouteItem(
          title: 'LoopBack Sample',
          push: (BuildContext context) {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new LoopBackSample()));
          }),
    ];
  }

}







