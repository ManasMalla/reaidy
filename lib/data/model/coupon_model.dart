import 'package:equatable/equatable.dart';
import 'package:reaidy/domain/entities/coupon.dart';

class CouponModel extends Equatable {
  final String id;
  final String code;
  final bool isForNewUsers;
  final int discount;
  final int maxDiscount;
  final int startAt;
  final int expireAt;
  final String label;
  final String description;
  final List<String> terms;
  final int lastModified;

  const CouponModel({
    required this.id,
    required this.code,
    required this.isForNewUsers,
    required this.discount,
    required this.maxDiscount,
    required this.startAt,
    required this.expireAt,
    required this.label,
    required this.description,
    required this.terms,
    required this.lastModified,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['_id'],
      code: json['code'],
      isForNewUsers: json['isItForNewUsers'],
      discount: json['discount'],
      maxDiscount: json['maxDiscount'],
      startAt: json['startAt'],
      expireAt: json['expireAt'],
      label: json['label'],
      description: json['description'],
      terms: List<String>.from(json['terms']),
      lastModified: json['lastModified'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['code'] = this.code;
    data['isItForNewUsers'] = this.isForNewUsers;
    data['discount'] = this.discount;
    data['maxDiscount'] = this.maxDiscount;
    data['startAt'] = this.startAt;
    data['expireAt'] = this.expireAt;
    data['label'] = this.label;
    data['description'] = this.description;
    data['terms'] = this.terms;
    data['lastModified'] = this.lastModified;
    return data;
  }

  Coupon toEntity() => Coupon(
        id: id,
        code: code,
        isForNewUsers: isForNewUsers,
        discount: discount,
        maxDiscount: maxDiscount,
        startAt: DateTime.fromMicrosecondsSinceEpoch(startAt * 1000),
        expireAt: DateTime.fromMicrosecondsSinceEpoch(expireAt * 1000),
        label: label,
        description: description,
        terms: terms,
        lastModified: DateTime.fromMicrosecondsSinceEpoch(lastModified * 1000),
      );

  @override
  List<Object?> get props => [id];
}
