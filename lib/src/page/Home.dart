import 'dart:io';

import 'package:Contacts/src/bloc/component/AppBloc.dart';
import 'package:Contacts/src/bloc/event/AppEvent.dart';
import 'package:Contacts/src/bloc/state/AppState.dart';
import 'package:Contacts/src/db/modal/Contact.dart';
import 'package:Contacts/src/page/AddContact.dart';
import 'package:Contacts/src/page/FavouritePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../Constants.dart';
import 'ContactDetail.dart';

typedef OnSaveCallback = Function();


class Home extends StatelessWidget {
    static const routeName = '/Home';
    List<Contact> contacts;

    Home({this.contacts});

    @override
    Widget build(BuildContext context) {
        void navigateToAddContact(context, route) async {
            Navigator.pop(context);
            Navigator.of(context).pushNamed(route);
        }


        return Scaffold(
            appBar: AppBar(
                title: Text(Constants.HOME),
            ),
            drawer: Drawer(
                child: ListView(
                    children: <Widget>[
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            color: Colors.red,
                            child: Text(
                                'Contacts',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                ),
                            ),
                        ),
                        InkWell(
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                        Icon(
                                            Icons.person_add,
                                            color: Colors.red,
                                            size: 30,
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8.0, 0, 0, 0),
                                            child: Text(
                                                'Add Contact',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                ),
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                            onTap: () {
                                navigateToAddContact(
                                    context, AddContact.routeName);
                            },
                        ),
                        InkWell(
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                        Icon(
                                            Icons.star,
                                            color: Colors.red,
                                            size: 30,
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8.0, 0, 0, 0),
                                            child: Text(
                                                Constants.FAVOURITE,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                ),
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                            onTap: () {
                                navigateToAddContact(
                                    context, FavouritePage.routeName);
                            },
                        ),
                    ],
                ),
            ),
            body: Stack(
                children: <Widget>[
                    Visibility(
                        child: Center(child: CircularProgressIndicator()),
                        visible: context
                            .bloc<AppBloc>()
                            .state is Loading,
                    ),
                    ListView.separated(
                        separatorBuilder: (context, index) {
                            return Divider(
                                height: 1,
                            );
                        },
                        itemCount: contacts.length,
                        itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () {
                                    Navigator.pushNamed(
                                        context, ContactDetail.routeName,
                                        arguments: ContactDetailArgs(
                                            id: contacts[index].id,
                                            onSave: () {
                                                context
                                                    .bloc<AppBloc>()
                                                    .add(OnDeleteEvent(
                                                    id: contacts[index].id));
                                            }));
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                            Row(
                                                children: <Widget>[
                                                    contacts[index].image !=
                                                        null ? CircleAvatar(
                                                        backgroundImage: FileImage(
                                                            File(contacts[index]
                                                                .image)),
                                                        backgroundColor: Colors
                                                            .black,
                                                        radius: 25,
                                                    ) : CircleAvatar(
                                                        backgroundImage: AssetImage(
                                                            Constants.userImage),
                                                        backgroundColor: Colors
                                                            .black,
                                                        radius: 25,
                                                    ),
                                                    Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(
                                                            10.0, 0, 0, 0),
                                                        child: Text(
                                                            contacts[index]
                                                                .name ?? '',
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                color: Colors
                                                                    .black,
                                                            ),
                                                        ),
                                                    ),
                                                ],
                                            ),
                                            Row(
                                                children: <Widget>[
                                                    IconButton(
                                                        icon: Icon(Icons.call),
                                                        onPressed: () {
                                                            },
                                                    ),
                                                    IconButton(
                                                        icon: Icon(
                                                            Icons.message),
                                                        onPressed: () {
                                                             }),
                                                ],
                                            ),
                                        ],
                                    ),
                                ),
                            );
                        }),
                ],
            ),
        );
    }
}
