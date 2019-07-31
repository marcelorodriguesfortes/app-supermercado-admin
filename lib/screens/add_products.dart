import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class AddProducts extends StatefulWidget {
  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  Color white = Colors.white;
  Color black = Colors.black;
  Color blue = Colors.blue;
  Color grey = Colors.grey;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        leading: Icon(Icons.close, color: black,),
        title: Text("add products", style: TextStyle(color: black),),
      ),
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlineButton(
                    borderSide: BorderSide(color: grey.withOpacity(0.8), width: 2.0),
                    onPressed:(){},
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 30.0, 14.0, 30.0),
                      child: new Icon(Icons.add, color: grey,),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlineButton(
                    borderSide: BorderSide(color: grey.withOpacity(0.8), width: 2.0),
                    onPressed:(){},
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 30.0, 14.0, 30.0),
                      child: new Icon(Icons.add, color: grey,),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlineButton(
                    borderSide: BorderSide(color: grey.withOpacity(0.8), width: 2.0),
                    onPressed:(){},
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14.0, 30.0, 14.0, 30.0),
                      child: new Icon(Icons.add, color: grey,),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
