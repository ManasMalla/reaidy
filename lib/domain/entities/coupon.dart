import 'package:equatable/equatable.dart';

class Coupon extends Equatable {
  final String id;
  final String code;
  final bool isForNewUsers;
  final int discount;
  final int maxDiscount;
  final DateTime startAt;
  final DateTime expireAt;
  final String label;
  final String description;
  final List<String> terms;
  final DateTime lastModified;

  Coupon({
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

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
