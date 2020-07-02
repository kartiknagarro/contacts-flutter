import 'package:equatable/equatable.dart';

final String columnId = 'id';
final String columnName = 'name';
final String columnMobile = 'mobile';
final String columnImage = 'image';

class Contact extends Equatable {
    int id;
    String name;
    String mobile;
    String image;

    @override
    bool get stringify => true;

    Contact({this.id, this.name, this.mobile,this.image});

    Map<String, dynamic> toMap() {
        var map = <String, dynamic>{
            columnId: id,
            columnName: name,
            columnMobile: mobile,
            columnImage: image,
        };
        return map;
    }

    Contact.fromMap(Map<String, dynamic> map) {
        id = map[columnId];
        name = map[columnName];
        mobile = map[columnMobile];
        image = map[columnImage];
    }

    @override
    List<Object> get props => [id, name, mobile,image];

    @override
    String toString() {
        return super.toString();
    }
}
