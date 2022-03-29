import 'package:finance/finance/repository/models/payment_method.dart';

class Finance {
  num? depositBalance;
  num? creditsBalance;
  num? promotionBalance;
  num? earnCreditBalance;
  num? total;
  num? autoRechargeAmount;
  num? autoRechargeMinAmount;
  bool? autoRechargeEnabled;
  PaymentMethod? primaryPaymentMethod;

  Finance({
    this.depositBalance,
    this.creditsBalance,
    this.promotionBalance,
    this.total,
    this.autoRechargeAmount,
    this.autoRechargeMinAmount,
    this.autoRechargeEnabled,
    this.earnCreditBalance,
    this.primaryPaymentMethod,
  });

  Finance.fromJson(data) {
    this.depositBalance = data['deposit_balance'] ?? 0.0;
    this.creditsBalance = data['credits_balance'] ?? 0.0;
    this.promotionBalance = data['promotion_balance'] ?? 0.0;
    this.earnCreditBalance = data['earn_credit_balance'] ?? 0.0;
    this.total = data['total'] ?? 0.0;
    this.autoRechargeAmount = data['auto_recharge_amount'] ?? 0.0;
    this.autoRechargeEnabled = data['auto_recharge_enabled'] ?? false;
    this.autoRechargeMinAmount = data['auto_recharge_min_amount'] ?? 0.0;
    this.primaryPaymentMethod = data['primary_payment_method'] != null
        ? PaymentMethod.fromJson(data['primary_payment_method'])
        : null;
  }

  Map<String, dynamic> toJson() => {
        'deposit_balance': this.depositBalance,
        'credits_balance': this.creditsBalance,
        'promotion_balance': this.promotionBalance,
        'earn_credit_balance': this.earnCreditBalance,
        'total': this.total,
        'auto_recharge_amount': this.autoRechargeAmount,
        'auto_recharge_enabled': this.autoRechargeEnabled,
        'auto_recharge_min_amount': this.autoRechargeMinAmount,
        'primary_payment_method': this.primaryPaymentMethod != null
            ? this.primaryPaymentMethod!.toJson()
            : null
      };

  Finance copyWith({
    num? depositBalance,
    num? creditsBalance,
    num? promotionBalance,
    num? earnCreditBalance,
    num? total,
    num? autoRechargeAmount,
    num? autoRechargeMinAmount,
    bool? autoRechargeEnabled,
    PaymentMethod? primaryPaymentMethod,
  }) =>
      Finance(
        depositBalance: depositBalance ?? this.depositBalance,
        creditsBalance: creditsBalance ?? this.creditsBalance,
        promotionBalance: promotionBalance ?? this.promotionBalance,
        earnCreditBalance: earnCreditBalance ?? this.earnCreditBalance,
        total: total ?? this.total,
        autoRechargeAmount: autoRechargeAmount ?? this.autoRechargeAmount,
        autoRechargeMinAmount:
            autoRechargeMinAmount ?? this.autoRechargeMinAmount,
        autoRechargeEnabled: autoRechargeEnabled ?? this.autoRechargeEnabled,
        primaryPaymentMethod: primaryPaymentMethod ?? this.primaryPaymentMethod,
      );
}
