import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {

  String name;
  int age;

  DetailsPage({@required this.name, @required this.age});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Details Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: ()=> Navigator.of(context).pop(),
        ),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name),
              SizedBox(height: 20,),
              Text(age.toString()),
          ]),
    ));
  }
}