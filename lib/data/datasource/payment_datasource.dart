import 'dart:convert';

import 'package:http/http.dart';
import 'package:reaidy/data/datasource/constants.dart';
import 'package:reaidy/data/model/coupon_model.dart';
import 'package:reaidy/data/server_exception.dart';

abstract class PaymentDataSource {
  Future<List<CouponModel>> fetchCoupons();
  Future<int> redeemCoupon(String userId, String code);
}

class RemotePaymentDataSource implements PaymentDataSource {
  final Client client;
  const RemotePaymentDataSource({
    required this.client,
  });
  @override
  Future<List<CouponModel>> fetchCoupons() async {
    final url = Uri.parse("$baseUrl/api/coupon/list-coupons");
    final response = await client.get(url);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result["success"]) {
        return result["data"].map<CouponModel>((e) {
          return CouponModel.fromJson(e);
        }).toList();
      } else {
        throw ServerException(result["message"]);
      }
    } else {
      throw const ServerException("Oops! Please try after some time.");
    }
  }

  @override
  Future<int> redeemCoupon(String userId, String code) async {
    final url = Uri.parse("$baseUrl/api/payment/redeem-promo-code");
    final response = await client.post(url,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({"userId": userId, "code": code}));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result["success"]) {
        return result["data"]["data"]["credits"];
      } else {
        throw ServerException(result["message"]);
      }
    } else {
      print(response.body);
      print(response.statusCode);
      throw const ServerException("Oops! Please try after some time.");
    }
  }
}
