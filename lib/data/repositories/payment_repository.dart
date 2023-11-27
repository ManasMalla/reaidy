import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:reaidy/data/datasource/payment_datasource.dart';
import 'package:reaidy/data/failure.dart';
import 'package:reaidy/data/server_exception.dart';
import 'package:reaidy/domain/entities/coupon.dart';
import 'package:reaidy/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentDataSource paymentDataSource;
  const PaymentRepositoryImpl({
    required this.paymentDataSource,
  });
  @override
  Future<Either<Failure, List<Coupon>>> fetchCoupons() async {
    try {
      final result = await paymentDataSource.fetchCoupons();
      return Right(
          result.map((couponModel) => couponModel.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(
        Failure(message: e.message),
      );
    } on SocketException {
      return const Left(
        Failure(message: "No Internet Connection"),
      );
    }
  }

  @override
  Future<Either<Failure, int>> redeemCoupon(String userId, String code) async {
    try {
      final result = await paymentDataSource.redeemCoupon(userId, code);
      return Right(result);
    } on ServerException catch (e) {
      return Left(
        Failure(message: e.message),
      );
    } on SocketException {
      return const Left(
        Failure(message: "No Internet Connection"),
      );
    }
  }
}
