import 'package:dartz/dartz.dart';
import 'package:reaidy/data/failure.dart';
import 'package:reaidy/domain/entities/coupon.dart';

abstract class PaymentRepository {
  Future<Either<Failure, List<Coupon>>> fetchCoupons();

  Future<Either<Failure, int>> redeemCoupon(String userId, String code);
}
