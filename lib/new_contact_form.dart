import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'model/contact.dart';

class NewContact extends StatefulWidget {
  @override
  _NewContactState createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name;
  String _age;

  void saveContact(){
    _formKey.currentState.save();
    Box<Contact> contactsBox = Hive.box('contacts');
    contactsBox.add(Contact(name: _name,age: int.parse(_age)));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Add contact'),
      children: [
        Column(
          children: [
            Container(
              height: 220,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.text_fields),
                            hintText: 'Name of person',
                            labelText: 'Name',
                          ),
                          keyboardType: TextInputType.text,
                          onSaved: (String name){
                            _name = name;
                          },
                        ),
                      ),
                      SizedBox(height: 24,),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.date_range),
                            hintText: 'Age of person',
                            labelText: 'Age',
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (String age){
                            _age = age;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                  onPressed: () => saveContact(),
                  child: Text('Add contact')
              ),
            ),
          ],
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            RaisedButton(
              child: Text('Save'),
              onPressed: () => saveContact(),
            )
          ],
        ),
      ],
    );

  }
}
