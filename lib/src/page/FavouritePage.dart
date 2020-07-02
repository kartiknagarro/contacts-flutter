import 'dart:io';

import 'package:Contacts/src/Constants.dart';
import 'package:Contacts/src/bloc/component/AppBloc.dart';
import 'package:Contacts/src/bloc/event/AppEvent.dart';
import 'package:Contacts/src/bloc/state/AppState.dart';
import 'package:Contacts/src/db/modal/Contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ContactDetail.dart';

class FavouritePage extends StatelessWidget {
    static const routeName = '/favourite';
    List<Contact> contacts;

    FavouritePage({this.contacts});


    @override
    Widget build(BuildContext mainContext) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Favourites'),
            ),
            body: BlocBuilder<AppBloc, AppState>(
                builder: (context, state) {
                    if (contacts.length == 0) {
                        return Center(
                            child: Text(Constants.NO_CONTACTS,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.red),),
                        );
                    } else {
                        return Stack(
                            children: <Widget>[
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
                                                                .add(
                                                                OnDeleteEvent(
                                                                    id: contacts[index]
                                                                        .id));
                                                        }));
                                            },
                                            child: Padding(
                                                padding: const EdgeInsets.all(
                                                    10),
                                                child: Row(
                                                    mainAxisSize: MainAxisSize
                                                        .max,
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .spaceBetween,
                                                    children: <Widget>[
                                                        Row(
                                                            children: <Widget>[
                                                                contacts[index]
                                                                    .image !=
                                                                    null
                                                                    ? CircleAvatar(
                                                                    backgroundImage: FileImage(
                                                                        File(
                                                                            contacts[index]
                                                                                .image)),
                                                                    backgroundColor: Colors
                                                                        .black,
                                                                    radius: 25,
                                                                )
                                                                    : CircleAvatar(
                                                                    backgroundImage: AssetImage(
                                                                        Constants.userImage),
                                                                    backgroundColor: Colors
                                                                        .black,
                                                                    radius: 25,
                                                                ),
                                                                Padding(
                                                                    padding: const EdgeInsets
                                                                        .fromLTRB(
                                                                        10.0, 0,
                                                                        0,
                                                                        0),
                                                                    child: Text(
                                                                        contacts[index]
                                                                            .name ??
                                                                            '',
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
                                                                    icon: Icon(
                                                                        Icons
                                                                            .call),
                                                                    onPressed: () {},
                                                                ),
                                                                IconButton(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .message),
                                                                    onPressed: () {}),
                                                            ],
                                                        ),
                                                    ],
                                                ),
                                            ),
                                        );
                                    })
                                ,
                            ]
                            ,
                        );
                    }
                },

            ),


        );
    }

}