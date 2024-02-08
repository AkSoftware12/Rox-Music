/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

SongModel songModelFromJson(String str) => SongModel.fromJson(json.decode(str));

String songModelToJson(SongModel data) => json.encode(data.toJson());

class SongModel {
    SongModel({
        required this.image5,
        required this.image3,
        required this.orderNo,
        required this.image4,
        required this.entryDate,
        required this.id,
        required this.image1,
        required this.image2,
        required this.productName,
    });

    String image5;
    String image3;
    int orderNo;
    String image4;
    String entryDate;
    int id;
    String image1;
    String image2;
    String productName;

    factory SongModel.fromJson(Map<dynamic, dynamic> json) => SongModel(
        image5: json["image5"],
        image3: json["image3"],
        orderNo: json["orderNo"],
        image4: json["image4"],
        entryDate: json["entryDate"],
        id: json["id"],
        image1: json["image1"],
        image2: json["image2"],
        productName: json["productName"],
    );

    Map<dynamic, dynamic> toJson() => {
        "image5": image5,
        "image3": image3,
        "orderNo": orderNo,
        "image4": image4,
        "entryDate": entryDate,
        "id": id,
        "image1": image1,
        "image2": image2,
        "productName": productName,
    };
}
