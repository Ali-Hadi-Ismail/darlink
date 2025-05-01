// ignore_for_file: constant_identifier_names

import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

import '../modules/authentication/login_screen.dart' as lg;
import 'Database_url.dart' as mg;

const mongo_url =
    ('mongodb+srv://salimshatila21:UfXFh4SuoVCusLO8@cluster0.p3mm2.mongodb.net/seniorDBtest1?retryWrites=true&w=majority&appName=Cluster0');

class MongoDatabase {
  static connect() async {
    var db = await Db.create(mongo_url);
    await db.open();
  }
}

Future<String> collect_user_info() async {
  var db = await mongo.Db.create(mg.mongo_url);
  await db.open();
  var collection = db.collection("user");
  var userDoc =
      await collection.findOne(mongo.where.eq("Email", lg.usermail)).toString();

  return userDoc;
}

Future<Map<String, dynamic>?> collect_info_properties(int id) async {
  var db = await mongo.Db.create(mg.mongo_url);
  await db.open();
  var collection = db.collection("Property");
  var property = await collection.findOne(where.eq("id", id));

  var p = await collection.findOne(where.sortBy("id", descending: true));
  print(p.toString());
  return property;
}
