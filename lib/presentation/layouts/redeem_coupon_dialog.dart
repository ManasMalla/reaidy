import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:reaidy/domain/entities/user.dart';
import 'package:reaidy/presentation/bloc/payments/payment_bloc.dart';
import 'package:reaidy/presentation/bloc/payments/payment_event.dart';
import 'package:reaidy/presentation/bloc/payments/payment_state.dart';
import 'package:reaidy/presentation/injector.dart';

class RedeemCouponDialog extends StatefulWidget {
  final User user;
  const RedeemCouponDialog({
    super.key,
    required this.user,
  });

  @override
  State<RedeemCouponDialog> createState() => _RedeemCouponDialogState();
}

class _RedeemCouponDialogState extends State<RedeemCouponDialog> {
  var isExpanded = false;
  var couponCodeEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BlocConsumer<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is RedemptionSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Coupon redeemed successfully"),
              ));
              Navigator.of(context).pop();
            }
          },
          bloc: Injector.paymentBloc,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: state is CouponListState
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Have a coupon code"),
                        const SizedBox(
                          height: 12,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: "Enter a coupon code",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  couponCodeEditingController.clear();
                                  setState(() {});
                                },
                                icon: const Icon(Icons.cancel_outlined),
                              )),
                          controller: couponCodeEditingController,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        FilledButton(
                          onPressed: () {
                            Injector.paymentBloc.add(
                              OnRedeemCoupon(
                                  user: widget.user,
                                  code: couponCodeEditingController.text),
                            );
                          },
                          child: const Text("Redeem"),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        isExpanded
                            ? Row(
                                children: [
                                  Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isExpanded = !isExpanded;
                                        });
                                      },
                                      icon: Icon(Icons.arrow_drop_up))
                                ],
                              )
                            : Row(
                                children: [
                                  const Flexible(
                                      child: Text(
                                    "Don't have a coupon code? ",
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isExpanded = !isExpanded;
                                      });
                                    },
                                    child: const Text("Get it here"),
                                  ),
                                ],
                              ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: !isExpanded
                              ? const SizedBox()
                              : ListView.builder(
                                  itemBuilder: (context, index) {
                                    final coupon = state.coupons[index];
                                    return Row(
                                      children: [
                                        Container(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            width: 24,
                                            height: 48,
                                            child: Center(
                                              child: Text(
                                                "%",
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary),
                                              ),
                                            )),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                coupon.code,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              Text(
                                                coupon.description,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                                maxLines: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Column(
                                          children: [
                                            OutlinedButton(
                                                onPressed:
                                                    couponCodeEditingController
                                                                .text ==
                                                            coupon.code
                                                        ? null
                                                        : () {
                                                            couponCodeEditingController
                                                                    .text =
                                                                coupon.code;
                                                            setState(() {});
                                                          },
                                                child: Text(
                                                    couponCodeEditingController
                                                                .text ==
                                                            coupon.code
                                                        ? "Applied"
                                                        : "Claim")),
                                            Text(
                                              DateFormat("MMM dd, yyyy")
                                                  .format(coupon.expireAt),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                  itemCount: state.coupons.length,
                                  shrinkWrap: true,
                                  primary: false,
                                ),
                        ),
                      ],
                    )
                  : state is PaymentFailureState
                      ? Center(child: Text(state.message))
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
            );
          }),
    );
  }
}
