import 'package:mongo_dart/mongo_dart.dart';

const Mongo_Url =
    ('mongodb+srv://salimshatila21:UfXFh4SuoVCusLO8@cluster0.p3mm2.mongodb.net/seniorDBtest1?retryWrites=true&w=majority&appName=Cluster0');

class MongoDatabase {
  static connect() async {
    var db = await Db.create(Mongo_Url);
    await db.open();
  }
}
