import 'package:Contacts/src/bloc/event/AppEvent.dart';
import 'package:Contacts/src/bloc/state/AppState.dart';
import 'package:Contacts/src/db/Database.dart';
import 'package:Contacts/src/db/modal/Contact.dart';
import 'package:Contacts/src/db/modal/Favourite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
    final LocalDb db;

    AppBloc(this.db);

    @override
    AppState get initialState => InitialState();

    @override
    Stream<AppState> mapEventToState(AppEvent event) async* {
        if (event is LoadEvent) {
            yield Loading();
            yield LoadSuccess(await db.getAll(), await db.getAllFav());
        } else if (event is AddEvent) {
            db.insert(contact: event.contact);
            Contact contact = await db.getLastRow();
            if (event.fav) {
                db.addToFav(favourite: Favourite(contactId: contact.id));
                Favourite favourite = await db.getLastFavRow();
                state.favouriteList.add(favourite);
            }
            state.contactList.add(contact);
            yield LoadSuccess(state.contactList, state.favouriteList);
        } else if (event is UpdateEvent) {
            db.update(contact: event.contact);
            Favourite favourite;
            try {
                favourite =
                    state.favouriteList.firstWhere((element) =>
                    element.contactId ==
                        event.contact.id);
            } on StateError {

            }
            if (favourite == null) {
                if (event.fav) {
                    db.addToFav(
                        favourite: Favourite(contactId: event.contact.id));
                    Favourite favourite = await db.getLastFavRow();
                    state.favouriteList.add(favourite);
                }
            } else if (!event.fav) {
                db.removeFromFav(contactId: event.contact.id);
                state.favouriteList.removeWhere((element) =>
                element.contactId == event.contact.id);
            }
            state.contactList
                .removeWhere((element) => element.id == event.contact.id);
            state.contactList.add(event.contact);
            yield LoadSuccess(state.contactList, state.favouriteList);
        } else if (event is OnDeleteEvent) {
            db.delete(id: event.id);
            if (state.favouriteList.contains(Favourite(contactId: event.id))) {
                db.removeFromFav(contactId: event.id);
                state.favouriteList.removeWhere((element) =>
                element.contactId == event.id);
            }
            state.contactList.removeWhere((element) => element.id == event.id);
            yield LoadSuccess(state.contactList, state.favouriteList);
        } else if (event is AddToFav) {
            db.addToFav(favourite: Favourite(contactId: event.contactId));
            Favourite favourite = await db.getLastFavRow();
            state.favouriteList.add(favourite);
            yield LoadSuccess(state.contactList, state.favouriteList);
        } else if (event is RemoveFromFav) {
            db.removeFromFav(contactId: event.contactId);
            state.favouriteList.removeWhere((element) =>
            element.contactId == event.contactId);
            yield LoadSuccess(state.contactList, state.favouriteList);
        }
    }
}
