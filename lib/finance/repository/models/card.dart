class CardModel {
  String? eventType;
  String? cardNumber;
  String? expiryDate;
  String? cardHolderName;
  String? cvvCode;
  String? clientId;

  CardModel(
      {this.eventType,
      this.cardNumber,
      this.expiryDate,
      this.cardHolderName,
      this.cvvCode,
      this.clientId});

  CardModel.fromJson(Map<String, dynamic> json) {
    eventType = json['eventType'];
    cardNumber = json['cardNumber'];
    expiryDate = json['expiryDate'];
    cardHolderName = json['cardHolderName'];
    cvvCode = json['cvvCode'];
    clientId = json['clientId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventType'] = this.eventType;
    data['cardNumber'] = this.cardNumber;
    data['expiryDate'] = this.expiryDate;
    data['cardHolderName'] = this.cardHolderName;
    data['cvvCode'] = this.cvvCode;
    data['clientId'] = this.clientId;
    return data;
  }
}

