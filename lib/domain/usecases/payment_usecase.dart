import 'package:dartz/dartz.dart';
import 'package:reaidy/data/failure.dart';
import 'package:reaidy/domain/entities/coupon.dart';
import 'package:reaidy/domain/repositories/payment_repository.dart';

class PaymentUseCase {
  final PaymentRepository paymentRepository;
  const PaymentUseCase({required this.paymentRepository});
  Future<Either<Failure, List<Coupon>>> fetchCoupons() {
    return paymentRepository.fetchCoupons();
  }

  Future<Either<Failure, int>> redeemCoupon(String userId, String code) {
    return paymentRepository.redeemCoupon(userId, code);
  }
}
