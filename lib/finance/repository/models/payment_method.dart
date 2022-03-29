class PaymentMethod {
  int? id;
  String? gateway;
  String? email;
  String? createdAt;
  int? user;
  bool? isPrimary;
  bool? isPrimaryAutoRecharge;
  bool? isBackup;
  String? gatewayBuyerId;
  String? gatewayPaymentMethodId;
  String? countryCode;
  String? firstName;
  String? lastName;
  bool? isEarnCredit;

  PaymentMethod({
    this.id,
    this.gateway,
    this.email,
    this.createdAt,
    this.user,
    this.isPrimary,
    this.isPrimaryAutoRecharge,
    this.isBackup,
    this.gatewayBuyerId,
    this.gatewayPaymentMethodId,
    this.countryCode,
    this.firstName,
    this.lastName,
    this.isEarnCredit,
  });

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gateway = json['gateway'];
    email = json['email'];
    createdAt = json['created_at'];
    user = json['user'];
    isPrimary = json['is_primary'];
    isPrimaryAutoRecharge = json['is_primary_auto_recharge'];
    isBackup = json['is_backup'];
    isEarnCredit = json['is_earn_credit'];
    gatewayBuyerId = json['gateway_buyer_id'];
    gatewayPaymentMethodId = json['gateway_payment_method_id'];
    countryCode = json['country_code'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['gateway'] = this.gateway;
    data['email'] = this.email;
    data['created_at'] = this.createdAt;
    data['user'] = this.user;
    data['is_primary'] = this.isPrimary;
    data['is_primary_auto_recharge'] = this.isPrimaryAutoRecharge;
    data['is_backup'] = this.isBackup;
    data['gateway_buyer_id'] = this.gatewayBuyerId;
    data['gateway_payment_method_id'] = this.gatewayPaymentMethodId;
    data['country_code'] = this.countryCode;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['is_earn_credit'] = this.isEarnCredit;
    return data;
  }

  PaymentMethod copyWith({
    int? id,
    String? gateway,
    String? email,
    String? createdAt,
    int? user,
    bool? isPrimary,
    bool? isPrimaryAutoRecharge,
    bool? isBackup,
    String? gatewayBuyerId,
    String? gatewayPaymentMethodId,
    String? countryCode,
    String? firstName,
    String? lastName,
    bool? isEarnCredit,
  }) =>
      PaymentMethod(
        id: id ?? this.id,
        gateway: gateway ?? this.gateway,
        email: email ?? this.email,
        createdAt: createdAt ?? this.createdAt,
        user: user ?? this.user,
        isPrimary: isPrimary ?? this.isPrimary,
        isPrimaryAutoRecharge:
            isPrimaryAutoRecharge ?? this.isPrimaryAutoRecharge,
        isBackup: isBackup ?? this.isBackup,
        gatewayBuyerId: gatewayBuyerId ?? this.gatewayBuyerId,
        gatewayPaymentMethodId:
            gatewayPaymentMethodId ?? this.gatewayPaymentMethodId,
        countryCode: countryCode ?? this.countryCode,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        isEarnCredit: isEarnCredit ?? this.isEarnCredit,
      );

  static List<PaymentMethod> fromJsonList(data) {
    if (data == null) return [];
    List<PaymentMethod> paymentMethods = [];
    data.forEach((data) => paymentMethods.add(PaymentMethod.fromJson(data)));
    paymentMethods.sort((a, b) {
      return a.id! - b.id!;
    });

    return paymentMethods;
  }
}
