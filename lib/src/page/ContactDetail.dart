import 'dart:io';

import 'package:Contacts/src/Constants.dart';
import 'package:Contacts/src/bloc/component/AppBloc.dart';
import 'package:Contacts/src/bloc/event/AppEvent.dart';
import 'package:Contacts/src/bloc/state/AppState.dart';
import 'package:Contacts/src/db/modal/Contact.dart';
import 'package:Contacts/src/db/modal/Favourite.dart';
import 'package:Contacts/src/page/AddContact.dart';
import 'package:Contacts/src/page/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactDetailArgs {
    OnSaveCallback onSave;
    int id;

    ContactDetailArgs({this.id, this.onSave});
}

class ContactDetail extends StatelessWidget {
    static const routeName = '/contactDetail';
    final Contact contact;
    final Favourite favourite;
    final OnSaveCallback callback;

    ContactDetail({this.contact, this.favourite, this.callback});

    void toggleFav(BuildContext context) {
        context.bloc<AppBloc>().add(
            favourite == null ? AddToFav(contactId: contact.id)
                : RemoveFromFav(contactId: contact.id)
        );
    }


    @override
    Widget build(BuildContext context) {
        if (contact == null) {
            return SizedBox.shrink();
        }

        return BlocBuilder<AppBloc, AppState>(
            builder: (context, state) {
                return Scaffold(
                    appBar: AppBar(
                        title: Text(contact.name ?? ''),
                        actions: <Widget>[
                            IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                    callback();
                                    Navigator.of(context).pop();
                                },
                            )
                        ],
                    ),
                    body: Center(
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                                Container(
                                    width: double.infinity,
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Stack(
                                            children: [
                                                Center(
                                                    child: contact.image == null
                                                        ? CircleAvatar(
                                                        radius: 60,
                                                        backgroundImage: AssetImage(
                                                            Constants.userImage))
                                                        : CircleAvatar(
                                                        radius: 60,
                                                        backgroundImage: FileImage(
                                                            File(contact
                                                                .image),),
                                                    )
                                                ),
                                                Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: IconButton(
                                                        onPressed: () {
                                                            toggleFav(context);
                                                        },
                                                        icon: Icon(
                                                            favourite != null
                                                                ? Icons.star
                                                                : Icons
                                                                .star_border,
                                                            color: Colors.red,
                                                            size: 25,
                                                        ),
                                                    ),
                                                )
                                            ],
                                        ),
                                    ),
                                ),
                                Container(
                                    margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: <Widget>[
                                            Text(
                                                contact.mobile ?? '',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.black,
                                                ),
                                            ),
                                            Row(
                                                children: <Widget>[
                                                    IconButton(
                                                        icon: Icon(Icons.call),
                                                        onPressed: () {},
                                                    ),
                                                    IconButton(
                                                        icon: Icon(
                                                            Icons.message),
                                                        onPressed: () {})
                                                ],
                                            ),
                                        ],
                                    ),
                                ),
                            ],
                        ),
                    ),
                    floatingActionButton: FloatingActionButton(
                        onPressed: () {
                            Navigator.pushNamed(
                                context, AddContact.routeName, arguments: contact.id);
                        },
                        child: Icon(
                            Icons.edit,
                            size: 20,
                        ),
                    ),
                );
            },
        );
    }
}
