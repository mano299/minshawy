import 'package:hive/hive.dart';

class HiveService {
  static Box<int> get favoritesBox =>
      Hive.box<int>('favorites');
  static Box get statsBox => Hive.box('stats');

}