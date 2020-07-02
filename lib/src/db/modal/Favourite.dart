import 'package:equatable/equatable.dart';

final String columnFavID = 'id';
final String columnContactId = 'contact_id';

// ignore: must_be_immutable
class Favourite extends Equatable {
    int id;
    int contactId;

    Favourite({this.id, this.contactId});

    Map<String, dynamic> toMap() {
        var map = <String, dynamic>{
            columnFavID: id,
            columnContactId: contactId
        };
        return map;
    }

    Favourite.fromMap(Map<String, dynamic> map) {
        id = map[columnFavID];
        contactId = map[columnContactId];
    }

    @override
    bool get stringify => true;

    @override
    List<Object> get props => [contactId];
}
