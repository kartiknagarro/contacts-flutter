import 'dart:async';

import 'package:Contacts/src/db/modal/Contact.dart';
import 'package:Contacts/src/db/modal/Favourite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDb {
    static const String CONTACT_TABLE = 'contacts';
    static const String FAV_CONTACT_TABLE = 'fav_contacts';
    static final LocalDb instance = LocalDb._internal();

    Database _database;

    LocalDb._internal();

    factory LocalDb() {
        return instance;
    }

    Future<Database> get database async {
        if (_database != null) return _database;
        _database = await createDatabase();
        return _database;
    }

    Future<Database> createDatabase() async {
        return await openDatabase(
            join(await getDatabasesPath(), 'Contacts-database'),
            onCreate: (db, version) {
                //Contact table
                db.execute(
                    "CREATE TABLE $CONTACT_TABLE($columnId INTEGER PRIMARY KEY, $columnName TEXT, $columnMobile TEXT,$columnImage TEXT)");
                // Favourite contact table
                db.execute(
                    "CREATE TABLE $FAV_CONTACT_TABLE($columnFavID INTEGER PRIMARY KEY,$columnContactId INTEGER)");
            }, version: 1);
    }

    void insert({Contact contact}) async {
        Database db = await instance.database;
        await db.insert(
            CONTACT_TABLE,
            contact.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
        );
    }

    Future<List<Contact>> getAll() async {
        Database db = await instance.database;
        List<Map<String, dynamic>> result = await db.query(CONTACT_TABLE);

        return List.generate(result.length, (index) {
            return Contact.fromMap(result[index]);
        });
    }

    void update({Contact contact}) async {
        Database db = await instance.database;
        await db.update(CONTACT_TABLE, contact.toMap(),
            where: "$columnId=?", whereArgs: [contact.id]);
    }

    void delete({int id}) async {
        Database db = await instance.database;
        await db.delete(CONTACT_TABLE, where: "$columnId=?", whereArgs: [id]);
    }

    Future<Contact> getLastRow() async {
        Database db = await instance.database;
        List<Map<String, dynamic>> result = await db.rawQuery(
            'SELECT * FROM $CONTACT_TABLE ORDER BY $columnId DESC LIMIT 1');

        return Contact.fromMap(result[0]);
    }

    Future<Set<Favourite>> getAllFav() async {
        Database db = await instance.database;
        List<Map<String, dynamic>> result = await db.query(FAV_CONTACT_TABLE);

        return List.generate(result.length, (index) {
            return Favourite.fromMap(result[index]);
        }).toSet();
    }

    void addToFav({Favourite favourite}) async {
        Database db = await instance.database;
        await db.insert(
            FAV_CONTACT_TABLE,
            favourite.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
        );
    }

    void removeFromFav({int contactId}) async {
        Database db = await instance.database;
        await db
            .delete(
            FAV_CONTACT_TABLE, where: "$columnContactId=?",
            whereArgs: [contactId]);
    }

    Future<Favourite> getLastFavRow() async {
        Database db = await instance.database;
        List<Map<String, dynamic>> result = await db.rawQuery(
            'SELECT * FROM $FAV_CONTACT_TABLE ORDER BY $columnFavID DESC LIMIT 1');

        return Favourite.fromMap(result[0]);
    }
}

