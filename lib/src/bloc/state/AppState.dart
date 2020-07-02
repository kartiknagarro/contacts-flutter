import 'dart:collection';

import 'package:Contacts/src/db/modal/Contact.dart';
import 'package:Contacts/src/db/modal/Favourite.dart';

abstract class AppState {
  List<Contact> get contactList => [];

  Set<Favourite> get favouriteList => HashSet();
}

class InitialState extends AppState {}

class Loading extends AppState {}

class LoadSuccess extends AppState {
  final List<Contact> data;
  final Set<Favourite> favList;

  LoadSuccess([this.data, this.favList]);

  @override
  List<Contact> get contactList => data;

  @override
  Set<Favourite> get favouriteList => favList;
}

//class UpdateSuccess extends AppState {
//  final List<Contact> data;
//  final List<Favourite> favList;
//
//  UpdateSuccess([this.data, this.favList]);
//
//  @override
//  List<Contact> get contactList => data;
//
//  @override
//  List<Favourite> get favouriteList => favList;
//}
//
//class SaveSuccess extends AppState {
//  final List<Contact> data;
//  final List<Favourite> favList;
//
//  SaveSuccess([this.data, this.favList]);
//
//  @override
//  List<Contact> get contactList => data;
//
//  List<Favourite> get favouriteList => favList;
//}
