import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gallery_array/classes/call.dart';
import 'package:gallery_array/pages/application/call_pickup.dart';
import 'package:gallery_array/pages/application/principal.dart';

import 'package:gallery_array/service/user_service.dart';
import 'package:provider/provider.dart';

class CallLayoutPage extends StatefulWidget {
  @override
  _CallLayoutPageState createState() => _CallLayoutPageState();
}

class _CallLayoutPageState extends State<CallLayoutPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  //final CallMethods callMethods = CallMethods();
  final UserService us = UserService();
  PickupLayout({
    @required this.scaffold
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
