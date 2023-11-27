import 'package:equatable/equatable.dart';
import 'package:reaidy/domain/entities/user.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
  @override
  List<Object?> get props => [];
}

class FetchCoupons extends PaymentEvent {
  const FetchCoupons();
}

class OnRedeemCoupon extends PaymentEvent {
  final User user;
  final String code;
  const OnRedeemCoupon({
    required this.user,
    required this.code,
  });
}
