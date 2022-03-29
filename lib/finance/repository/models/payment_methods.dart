// To parse this JSON data, do
//
//     final paymentMethods = paymentMethodsFromMap(jsonString);

import 'dart:convert';

class PaymentMethods {
    PaymentMethods({
        this.methods,
    });

    final List<Method>? methods;

    PaymentMethods copyWith({
        List<Method>? methods,
    }) => 
        PaymentMethods(
            methods: methods ?? this.methods,
        );

    factory PaymentMethods.fromJson(String str) => PaymentMethods.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PaymentMethods.fromMap(Map<String, dynamic> json) => PaymentMethods(
        methods:json["payments"] == null ? [ ] :  List<Method>.from(json["payments"].map((x) => Method.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "payments": List<dynamic>.from(methods!.map((x) => x.toMap())),
    };
}

class Method {
    Method({
        this.priority,
        this.id,
        this.uid,
        this.cardNumber,
        this.expiryDate,
        this.cardHolderName,
        this.cvvCode,
        this.clientId,
        this.cardBrand,
    });

    final String? priority;
    final String? id;
    final String? uid;
    final String? cardNumber;
    final String? expiryDate;
    final String? cardHolderName;
    final String? cvvCode;
    final String? clientId;
    final String? cardBrand;

    Method copyWith({
        String? priority,
        String? id,
        String? uid,
        String? cardNumber,
        String? expiryDate,
        String? cardHolderName,
        String? cvvCode,
        String? clientId,
        String? cardBrand,
    }) => 
        Method(
            priority: priority ?? this.priority,
            id: id ?? this.id,
            uid: uid ?? this.uid,
            cardNumber: cardNumber ?? this.cardNumber,
            expiryDate: expiryDate ?? this.expiryDate,
            cardHolderName: cardHolderName ?? this.cardHolderName,
            cvvCode: cvvCode ?? this.cvvCode,
            clientId: clientId ?? this.clientId,
            cardBrand: cardBrand ?? this.cardBrand,
        );

    factory Method.fromJson(String str) => Method.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Method.fromMap(Map<String, dynamic> json) => Method(
        priority: json["priority"] == null ? null : json["priority"],
        id: json["_id"] == null ? null : json["_id"],
        uid: json["uid"] == null ? null : json["uid"],
        cardNumber: json["cardNumber"] == null ? null : json["cardNumber"],
        expiryDate: json["expiryDate"] == null ? null : json["expiryDate"],
        cardHolderName: json["cardHolderName"] == null ? null : json["cardHolderName"],
        cvvCode: json["cvvCode"] == null ? null : json["cvvCode"],
        clientId: json["clientId"] == null ? null : json["clientId"],
        cardBrand: json["cardBrand"] == null ? null : json["cardBrand"],
    );

    Map<String, dynamic> toMap() => {
        "priority": priority == null ? null : priority,
        "_id": id == null ? null : id,
        "uid": uid == null ? null : uid,
        "cardNumber": cardNumber == null ? null : cardNumber,
        "expiryDate": expiryDate == null ? null : expiryDate,
        "cardHolderName": cardHolderName == null ? null : cardHolderName,
        "cvvCode": cvvCode == null ? null : cvvCode,
        "clientId": clientId == null ? null : clientId,
        "cardBrand": cardBrand == null ? null : cardBrand,
    };
}
