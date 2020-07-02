import 'package:Contacts/src/bloc/event/AppEvent.dart';
import 'package:Contacts/src/db/Database.dart';
import 'package:Contacts/src/db/modal/Contact.dart';
import 'package:Contacts/src/db/modal/Favourite.dart';
import 'package:Contacts/src/page/AddContact.dart';
import 'package:Contacts/src/page/ContactDetail.dart';
import 'package:Contacts/src/page/FavouritePage.dart';
import 'package:Contacts/src/page/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Constants.dart';
import 'bloc/component/AppBloc.dart';
import 'bloc/state/AppState.dart';

class App extends StatelessWidget {

    List<Contact> getContacts(BuildContext context) {
        return context
            .bloc<AppBloc>()
            .state
            .contactList;
    }

    Set<Favourite> getFavourites(BuildContext context) {
        return context
            .bloc<AppBloc>()
            .state
            .favouriteList;
    }

    List<Contact> getFavouriteContacts(BuildContext context) {
        List<Contact> contacts = getContacts(context);
        Set<Favourite> favourites = getFavourites(context);
        List<Contact> result = List();
        favourites.forEach((element) {
            result.add(contacts.firstWhere((element1) =>
            element.contactId ==
                element1.id));
        });
        return result;
    }

    Contact getContact(BuildContext context, int contactId) {
        try {
            return getContacts(context)
                .firstWhere((element) => element.id == contactId);
        } on StateError {
            return null;
        }
    }

    Favourite getFavourite(BuildContext context, int contactId) {
        try {
            return getFavourites(context)
                .firstWhere((element) => element.contactId == contactId);
        } on StateError {
            return null;
        }
    }

    @override
    Widget build(BuildContext context) {
        return RepositoryProvider<LocalDb>(
            create: (context) => LocalDb(),
            child: MultiBlocProvider(
                providers: [
                    BlocProvider<AppBloc>(
                        create: (context) =>
                        AppBloc(context.repository<LocalDb>())
                            ..add(LoadEvent())),
                ],
                child: BlocBuilder<AppBloc, AppState>(
                    builder: (BuildContext context, AppState state) {
                        return MaterialApp(
                            title: Constants.APP_NAME,
                            initialRoute: Home.routeName,
                            theme: ThemeData(
                                accentColor: Colors.red,
                                primaryColor: Colors.red,
                                buttonColor: Colors.red),

                            onGenerateRoute: (RouteSettings setting) {
                                switch (setting.name) {
                                    case Home.routeName:
                                        return MaterialPageRoute(
                                            builder: (context) =>
                                                Home(
                                                    contacts: getContacts(
                                                        context),));
                                    case AddContact.routeName:
                                        return MaterialPageRoute(
                                            builder: (context) {
                                                int contactId = setting
                                                    .arguments;
                                                return AddContact(
                                                    contact: getContact(
                                                        context, contactId),
                                                    fav: getFavourite(
                                                        context, contactId));
                                            });
                                    case ContactDetail.routeName:
                                        return MaterialPageRoute(
                                            builder: (context) {
                                                ContactDetailArgs args = setting
                                                    .arguments as ContactDetailArgs;

                                                return ContactDetail(
                                                    contact: getContact(
                                                        context, args.id),
                                                    favourite: getFavourite(
                                                        context, args.id),
                                                    callback: args.onSave);
                                            }
                                        );
                                    case FavouritePage.routeName:
                                        return MaterialPageRoute(
                                            builder: (context) {
                                                return FavouritePage(
                                                    contacts: getFavouriteContacts(
                                                        context),);
                                            }
                                        );
                                    default:
                                        return null;
                                }
                            },
                        );
                    },
                ),
            ));
    }
}
