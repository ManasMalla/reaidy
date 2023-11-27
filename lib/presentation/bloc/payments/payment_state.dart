import 'package:equatable/equatable.dart';
import 'package:reaidy/domain/entities/coupon.dart';

class PaymentState extends Equatable {
  const PaymentState();
  @override
  List<Object?> get props => [];
}

class PaymentLoadingState extends PaymentState {
  const PaymentLoadingState();
}

class CouponListState extends PaymentState {
  final List<Coupon> coupons;
  const CouponListState({required this.coupons});
}

class PaymentFailureState extends PaymentState {
  final String message;
  const PaymentFailureState({required this.message});
}

class RedemptionSuccessState extends PaymentState {
  const RedemptionSuccessState();
}
