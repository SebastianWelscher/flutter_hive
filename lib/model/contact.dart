import 'package:hive/hive.dart';

part 'contact.g.dart';

@HiveType(typeId: 1)
class Contact extends HiveObject{
  static const int typeId = 1;
  @HiveField(0)
  String name;
  @HiveField(1)
  int age;

  Contact({this.name,this.age});

}
