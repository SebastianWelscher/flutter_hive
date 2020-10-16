import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/contact.dart';
import 'package:flutter_hive/new_contact_form.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:highlighter_coachmark/highlighter_coachmark.dart';
import 'detailsPage.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final GlobalKey _fabKey = GlobalObjectKey('fab');
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
  void initState() {
    super.initState();
   // Timer(Duration(seconds: 3),()=> showCoachMarkFab());
  }

  void showCoachMarkFab(){
    CoachMark coachMarkFAB = CoachMark();
    RenderBox target = _fabKey.currentContext.findRenderObject();
    Rect markRect = target.localToGlobal(Offset.zero) & target.size;
    markRect = Rect.fromLTWH(markRect.left, markRect.top, markRect.width, markRect.height);

    coachMarkFAB.show(
        targetContext: _fabKey.currentContext,
        children:[ Center(
          child: Text('Tippe auf Button um\neine Person hinzuzufügen',
          style: const TextStyle(
            fontSize: 24,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),),
        ),
        ],
        markRect: markRect,
        duration: null,
    );
  }

   _inputDialog() {
     showDialog(
      context: context,
    builder: (BuildContext context){
     return SimpleDialog(
        title: Text('Kontakt hinzufügen',
        style: GoogleFonts.comfortaa(
          textStyle: TextStyle(
            fontSize: 18,
          )
        ),),
        children: [
          Container(
            width: 400,
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          style: GoogleFonts.comfortaa(
                            textStyle: TextStyle(
                              fontSize: 15,),
                          ),
                          decoration: InputDecoration(
                            icon: Icon(Icons.text_fields),
                            hintText: 'Name der Person',
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
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                           style: GoogleFonts.comfortaa(
                           textStyle: TextStyle(
                           fontSize: 15,),
                           ),
                          decoration: InputDecoration(
                            icon: Icon(Icons.date_range),
                            hintText: 'Alter der Person',
                            labelText: 'Alter',
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
              ],
            ),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                child: Text('zurück',
                  style: GoogleFonts.comfortaa(
                    textStyle: TextStyle(
                      fontSize: 15,),
                  ),),
                onPressed: () => Navigator.of(context).pop(),
                color: Colors.white,
              ),

              SimpleDialogOption(
                child: Text('Hinzufügen',
                  style: GoogleFonts.comfortaa(
                    textStyle: TextStyle(
                      fontSize: 15,),
                  ),),
                onPressed: saveContact,
              )
            ],
          ),
        ],
      );
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Hive contacts',
        style: GoogleFonts.comfortaa(
        textStyle: TextStyle(
        fontSize: 28,
    ),
    ),
      ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Contact>('contacts').listenable(),
        builder: (BuildContext context, Box<Contact> box, _) {
          if(box.values.isEmpty){
            return Center(
              child: Text('Kontakt Box is leer',
                style: GoogleFonts.comfortaa(
                textStyle: TextStyle(
                fontSize: 25,),
                ),
              ),
            );
          }
          return ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (context, index){
                Contact contact = box.getAt(index);
               // print('ListView');
                return ListTile(
                  title: Text(contact.name,
                    style: GoogleFonts.comfortaa(
                    textStyle: TextStyle(
                    fontSize: 20,
                    ),
                ),),
                  subtitle: Text(contact.age.toString(),
                    style: GoogleFonts.comfortaa(
                      textStyle: TextStyle(
                        fontSize: 15,),
                    ),),
                  onTap: ()=> Navigator.push(
                      context, MaterialPageRoute(
                    builder: (context)=> DetailsPage(
                      name: contact.name,age: contact.age,),)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      IconButton(
                        icon: Icon(Icons.update),
                        onPressed: (){
                          return box.putAt(
                            index,
                            Contact(name: contact.name,age: contact.age +1));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => box.deleteAt(index),
                      ),
                    ],
                  ),
                );
              });
        },

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          key: _fabKey,
          onPressed: ()=> _inputDialog(),
          label: Text('Kontakt hinzufügen',
            style: GoogleFonts.comfortaa(
              textStyle: TextStyle(
                fontSize: 18,),
            ),),
      ),
    );
  }
}