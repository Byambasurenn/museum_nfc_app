import 'dart:io';
import 'package:museumnfcapp/models/Exhibit.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String tableExhibits = 'exhibits';

final String columnId = 'id';
final String columnNfcId = 'nfc_id';
final String columnTitle = 'title';
final String columnTitleEn = 'title_en';
final String columnDescription = 'description';
final String columnDescriptionEn = 'description_en';
final String columnImage = 'image';
final String columnAudio = 'audio';
final String columnAudioEn = 'audio_en';

// singleton class to manage the database
class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "ExhibitMuseumDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute(" CREATE TABLE $tableExhibits ($columnId INTEGER PRIMARY KEY, $columnNfcId TEXT NOT NULL, $columnTitle TEXT NOT NULL,$columnTitleEn TEXT NOT NULL, $columnDescription TEXT NOT NULL, $columnDescriptionEn TEXT NOT NULL, $columnImage TEXT NOT NULL, $columnAudio TEXT NOT NULL, $columnAudioEn TEXT NOT NULL)");
  }

  // Database helper methods:

  Future<int> insert(Exhibit exhibit) async {
    Database db = await database;
    int id = await db.insert(tableExhibits, exhibit.toMap());
    return id;
  }

  Future<Exhibit> queryExhibit(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableExhibits,
        columns: [columnId, columnNfcId, columnTitle, columnTitleEn, columnDescription, columnDescriptionEn, columnImage, columnAudio, columnAudioEn],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Exhibit.fromJson(maps.first);
    }
    return null;
  }

  Future<Exhibit> queryExhibitWithNfc(String nfcId) async {
    Database db = await database;
    List<Map> maps = await db.query(tableExhibits,
        columns: [columnId, columnNfcId, columnTitle, columnTitleEn, columnDescription, columnDescriptionEn, columnImage, columnAudio, columnAudioEn],
        where: '$columnNfcId = ?',
        whereArgs: [nfcId]);
    if (maps.length > 0) {
      return Exhibit.fromJson(maps.first);
    }
    return null;
  }

  Future<int> queryDeleteRow(String nfcId) async {
    Database db = await database;
    int result = await db.delete(tableExhibits, where: '$columnNfcId = ?',
        whereArgs: [nfcId]);
    if (result > 0) {
      return result;
    }
    return null;
  }


  Future<List<Exhibit>> queryAllExhibit() async {
    Database db = await database;
    List<Exhibit> exList = new List();
    List<Map> maps = await db.query(tableExhibits,
        columns: [columnId, columnNfcId, columnTitle, columnTitleEn, columnDescription, columnDescriptionEn, columnImage, columnAudio, columnAudioEn],);
    if (maps.length > 0) {
      for(var i = 0; i<maps.length; i++){
        exList.add(Exhibit.fromJson(maps[i]));
        print(maps[i].keys);
        print(exList);
      }
      print(exList);
      return exList;
    }
    return exList;
  }

// TODO: update(Word word)
}