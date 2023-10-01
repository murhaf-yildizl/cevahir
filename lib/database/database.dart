import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataBaseHelper
{

static Database _database;
String database_name="customers218.db";
static String _table_name;
static String path;


  static set_database(String new_path)async {
                        path=new_path;
                        _database=null;
  }

  DataBaseHelper.privateConstructor();
static final DataBaseHelper instance=DataBaseHelper.privateConstructor();


Future<Database> get database async
{
  //print("path=$path");

  if(_database!=null)
    return _database;

 final pref=await SharedPreferences.getInstance();
  path=pref.getString("db_path");
  print("YYYYYYYYYY${path}");

    if(path!=null && path.isNotEmpty)
           _database=await openDatabase(path,  version: 1,
         onConfigure:_onconfigure ,
         onCreate:(db,version)async
         {

           await db.execute("CREATE TABLE customers(customer_id INTEGER PRIMARY KEY,name TEXT,phone TEXT,address TEXT,logo TEXT)");
           await db.execute("CREATE TABLE models(model_id INTEGER PRIMARY KEY,nomune TEXT DEFAULT 'NO',model_no TEXT,price DOUBLE,customer_id INTEGER,date TEXT )");
           await db.execute("CREATE TABLE inci(inci_id INTEGER PRIMARY KEY,type TEXT,qnty INTEGER,weight DOUBLE,notes TEXT,material_id INTEGER,model_id INTEGER,FOREIGN KEY (model_id) REFERENCES models(model_id) ON DELETE CASCADE ON UPDATE CASCADE)");
           await db.execute("CREATE TABLE material(material_id INTEGER PRIMARY KEY,type TEXT,class_type TEXT,color TEXT,per_kilo DOUBLE,qnty DOUBLE,notes TEXT)");
           await db.execute("CREATE TABLE orders(order_id INTEGER PRIMARY KEY,date TEXT,qnty INTEGER,total_price DOUBLE,model_id INTEGER ,model_id INTEGER )");
           await db.execute("CREATE TABLE details(details_id INTEGER PRIMARY KEY,title TEXT,inci_size TEXT,quantity INTEGER,notes TEXT ,model_id INTEGER,FOREIGN KEY (model_id) REFERENCES models(model_id) ON DELETE CASCADE ON UPDATE CASCADE)");
           await db.execute("CREATE TABLE images(image_id INTEGER PRIMARY KEY,url TEXT,title TEXT,model_id INTEGER,FOREIGN KEY (model_id) REFERENCES models(model_id) ON DELETE CASCADE ON UPDATE CASCADE)");
           await db.execute("CREATE TABLE recipt(recipt_id INTEGER PRIMARY KEY,origin TEXT,date TEXT,total DOUBLE)");
           await db.execute("CREATE TABLE recipt_content(content_id INTEGER PRIMARY KEY,unit_price DOUBLE,material_id INTEGER,recipt_id INTEGER,content_qnty DOUBLE,content_notes TEXT)");
           await db.execute("CREATE TABLE setting(setting_id INTEGER PRIMARY KEY,company_name TEXT,password TEXT DEFAULT '1111',logo TEXT)");
           await db.execute("CREATE TABLE start_images(image_id INTEGER PRIMARY KEY,url BLOB,title TEXT,model_id INTEGER)");

         } );
 else _database=await openDatabase(join(await getDatabasesPath(),database_name),
                   version: 1,
                   onConfigure:_onconfigure ,
                   onCreate:(db,version)async
                     {

                       await db.execute("CREATE TABLE customers(customer_id INTEGER PRIMARY KEY,name TEXT,phone TEXT,address TEXT,logo TEXT)");
                       await db.execute("CREATE TABLE models(model_id INTEGER PRIMARY KEY,nomune TEXT DEFAULT 'NO',model_no TEXT,price DOUBLE,customer_id INTEGER,date TEXT )");
                       await db.execute("CREATE TABLE inci(inci_id INTEGER PRIMARY KEY,type TEXT,qnty INTEGER,weight DOUBLE,notes TEXT,material_id INTEGER,model_id INTEGER,FOREIGN KEY (model_id) REFERENCES models(model_id) ON DELETE CASCADE ON UPDATE CASCADE)");
                       await db.execute("CREATE TABLE material(material_id INTEGER PRIMARY KEY,type TEXT,class_type TEXT,color TEXT,per_kilo DOUBLE,qnty DOUBLE,notes TEXT)");
                       await db.execute("CREATE TABLE orders(order_id INTEGER PRIMARY KEY,date TEXT,qnty INTEGER,total_price DOUBLE,model_id INTEGER ,FOREIGN KEY (model_id) REFERENCES models(model_id) ON DELETE CASCADE ON UPDATE CASCADE)");
                       await db.execute("CREATE TABLE details(details_id INTEGER PRIMARY KEY,title TEXT,inci_size TEXT,quantity INTEGER,notes TEXT ,model_id INTEGER,FOREIGN KEY (model_id) REFERENCES models(model_id) ON DELETE CASCADE ON UPDATE CASCADE)");
                       await db.execute("CREATE TABLE images(image_id INTEGER PRIMARY KEY,url BLOB,title TEXT,model_id INTEGER,FOREIGN KEY (model_id) REFERENCES models(model_id) ON DELETE CASCADE ON UPDATE CASCADE)");
                       await db.execute("CREATE TABLE recipt(recipt_id INTEGER PRIMARY KEY,origin TEXT,date TEXT,total DOUBLE)");
                       await db.execute("CREATE TABLE recipt_content(content_id INTEGER PRIMARY KEY,unit_price DOUBLE,material_id INTEGER,recipt_id INTEGER,content_qnty DOUBLE,content_notes TEXT)");
                       await db.execute("CREATE TABLE setting(setting_id INTEGER PRIMARY KEY,company_name TEXT,password TEXT,logo TEXT)");
                       await db.execute("CREATE TABLE start_images(image_id INTEGER PRIMARY KEY,url BLOB,title TEXT,model_id INTEGER)");

                     } );

  if(_database!=null)
   {
     pref.setString("db_path",_database.path);
     return _database;
   }

}
  static Future<dynamic> update(String qw)async
{
  Database db=await DataBaseHelper.instance.database;
  await db.execute(qw);
}

   static Future<void> delete(String st) async
    {
      Database db=await DataBaseHelper.instance.database;
      await db.execute(st).then((var value) => value);
    }

static Future _onconfigure(Database db)async
{
  await db.execute("PRAGMA foreign_keys=ON");
}

      static Future<int> insertToDataBase(String table,Map<String,dynamic> row)async
      {
        _table_name=table;

        Database db=await DataBaseHelper.instance.database;
            return   db.insert(_table_name, row).then((value) => value);
       }

      static Future<List<Map<String,dynamic>>> import_from_dadabase(String qu) async
      {
        print(qu);
        Database db=await DataBaseHelper.instance.database;
        print("rrrrrrrr ${db.path}");
        List<Map<String,dynamic>>lst= await db.rawQuery(qu);

       return lst;
      }


static Future<int>  getcount(String qw)async
      {

        Database db=await DataBaseHelper.instance.database;
         List<Map<String,dynamic>> result=await db.rawQuery(qw);
         return Sqflite.firstIntValue(result);
      }

static Future<String> getpath()async
{
  Database db=await DataBaseHelper.instance.database;
  return db.path;


}



}
