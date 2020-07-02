import 'package:Contacts/src/db/modal/Contact.dart';
import 'package:Contacts/src/db/modal/Favourite.dart';

enum Event { LOAD_CONTACTS }

abstract class AppEvent {}

class LoadEvent extends AppEvent {}

class UpdateEvent extends AppEvent {
    Contact contact;
    bool fav;

    UpdateEvent({this.contact, this.fav});
}

class AddEvent extends AppEvent {
    Contact contact;
    bool fav;

    AddEvent({this.contact, this.fav});
}

class OnDeleteEvent extends AppEvent {
    int id;

    OnDeleteEvent({this.id});
}

class AddToFav extends AppEvent {
    int contactId;

    AddToFav({this.contactId});
}

class RemoveFromFav extends AppEvent {
    int contactId;

    RemoveFromFav({this.contactId});
}
