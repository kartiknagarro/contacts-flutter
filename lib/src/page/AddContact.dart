import 'dart:io';

import 'package:Contacts/src/Constants.dart';
import 'package:Contacts/src/bloc/component/AppBloc.dart';
import 'package:Contacts/src/bloc/event/AppEvent.dart';
import 'package:Contacts/src/db/modal/Contact.dart';
import 'package:Contacts/src/db/modal/Favourite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class AddContact extends StatefulWidget {
    static const routeName = '/addContact';
    Contact contact;
    Favourite fav;

    AddContact({this.contact, this.fav});

    @override
    State<StatefulWidget> createState() =>
        _AddContact(contact: contact, fav: fav);

}

class _AddContact extends State<AddContact> {
    Contact contact;
    Favourite fav;
    String name;
    String mobile;
    bool isFav = false;
    File _image;

    _AddContact({this.contact, this.fav});

    void toggleFav(value) {
        setState(() {
            isFav = value;
        });
    }

    final picker = ImagePicker();

    Future getImage() async {
        final pickedFile = await picker.getImage(source: ImageSource.gallery);

        setState(() {
            _image = File(pickedFile.path);
        });
    }

    void submit(BuildContext context) async {
        String path;
        if (name == null || mobile == null) {
            Scaffold.of(context).showSnackBar(
                new SnackBar(
                    content: Text(Constants.validation_msg),
                    backgroundColor: Colors.red,));
            return;
        }
        if (_image != null) {
            final Directory directory = await getApplicationDocumentsDirectory();
            final File localImage = await _image.copy(
                '${directory.path}/$name-${DateTime
                    .now()
                    .millisecondsSinceEpoch}.jpg');
            path = localImage.path;
        }
        if (contact == null) {
            context.bloc<AppBloc>().add(
                AddEvent(contact: Contact(
                    name: name,
                    mobile: mobile,
                    image: path),
                    fav: isFav));
        } else {
            context.bloc<AppBloc>().add(UpdateEvent(
                contact: Contact(
                    id: contact.id,
                    name: name,
                    mobile: mobile,
                    image: path),
                fav: isFav
            ));
        }
        Navigator.of(context).pop();
    }

    @override
    void initState() {
        setState(() {
            isFav = fav != null;
        });
        if (contact != null) {
            name = contact.name;
            mobile = contact.mobile;
            if (contact.image != null)
                _image = File(contact.image);
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: Text(Constants.ADD_CONTACT)),
            body: Builder(
                builder: (context) =>
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(children: <Widget>[
                            Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Column(children: [
                                    InkWell(
                                        onTap: getImage,
                                        child: _image == null
                                            ? CircleAvatar(
                                            backgroundImage: AssetImage(
                                                Constants.uploadImage),
                                            radius: 60,
                                        )
                                            : CircleAvatar(
                                            backgroundImage: FileImage(_image),
                                            radius: 60,
                                        )
                                    ),
                                    TextFormField(
                                        keyboardType: TextInputType.text,
                                        initialValue: name,
                                        decoration: InputDecoration(
                                            labelText: Constants.enterName,
                                            alignLabelWithHint: true),
                                        onChanged: (text) {
                                            name = text;
                                        },
                                    ),
                                    TextFormField(
                                        initialValue: mobile,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                            labelText: Constants.enterMobile,
                                            alignLabelWithHint: true),
                                        onChanged: (text) {
                                            mobile = text;
                                        },
                                    ),
                                    CheckboxListTile(
                                        title: Text(Constants.addToFav),
                                        value: isFav,
                                        onChanged: (value) {
                                            toggleFav(value);
                                        },
                                        controlAffinity: ListTileControlAffinity
                                            .leading, //  <-- leading Checkbox
                                    )
                                ])),
                            Positioned(
                                bottom: 0,
                                left: 10,
                                right: 10,
                                child: RaisedButton(
                                    child: Text(
                                        null == contact
                                            ? Constants.ADD_CONTACT
                                            : Constants.UPDATE_CONTACT,
                                        style: TextStyle(color: Colors.white),),
                                    onPressed: () {
                                        submit(context);
                                    }
                                ),
                            )
                        ]),
                    ),
            ));
    }
}
