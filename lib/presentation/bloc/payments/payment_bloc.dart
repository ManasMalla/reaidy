import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reaidy/domain/usecases/payment_usecase.dart';
import 'package:reaidy/presentation/bloc/auth/auth_event.dart';
import 'package:reaidy/presentation/bloc/payments/payment_event.dart';
import 'package:reaidy/presentation/bloc/payments/payment_state.dart';
import 'package:reaidy/presentation/injector.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentUseCase paymentUseCase;

  PaymentBloc({
    required this.paymentUseCase,
  }) : super(const PaymentLoadingState()) {
    on<FetchCoupons>((event, emit) async {
      emit(const PaymentLoadingState());
      final response = await paymentUseCase.fetchCoupons();
      response.fold(
        (failure) => emit(
          PaymentFailureState(message: failure.message),
        ),
        (coupons) {
          emit(CouponListState(coupons: coupons));
        },
      );
    });
    on<OnRedeemCoupon>((event, emit) async {
      emit(const PaymentLoadingState());
      final response =
          await paymentUseCase.redeemCoupon(event.user.id, event.code);
      response.fold(
        (failure) => emit(
          PaymentFailureState(message: failure.message),
        ),
        (coinsIncrement) {
          Injector.authBloc.add(
            UpdateUserData(
              googleId: event.user.googleId,
              userData: const {},
            ),
          );
          emit(RedemptionSuccessState());
        },
      );
    });
  }
}
