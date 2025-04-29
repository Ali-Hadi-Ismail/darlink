// ignore_for_file: constant_identifier_names

import 'package:mongo_dart/mongo_dart.dart';

const mongo_url =
    ('mongodb+srv://salimshatila21:password@cluster0.p3mm2.mongodb.net/seniorDBtest1?retryWrites=true&w=majority&appName=Cluster0');

class MongoDatabase {
  static connect() async {
    var db = await Db.create(mongo_url);
    await db.open();
  }
}
