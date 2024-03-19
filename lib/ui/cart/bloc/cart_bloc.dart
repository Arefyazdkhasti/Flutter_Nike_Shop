import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_shop/common/exceptions.dart';
import 'package:nike_shop/data/cart_response.dart';
import 'package:nike_shop/data/repo/cart_repository.dart';

import '../../../data/auth_info.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ICartRepository cartRepository;

  CartBloc(this.cartRepository) : super(CartLoading()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStarted) {
        final authInfo = event.authInfo;
        if (authInfo == null || authInfo.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          await loadCartItems(emit);
        }
      } else if (event is CartAuthInfoChanged) {
        final authInfo = event.authInfo;
        if (authInfo == null || authInfo.accessToken.isEmpty) {
          //user where logged in but not any more
          emit(CartAuthRequired());
        } else {
          if (state is CartAuthRequired) {
            //refresh loading items when user login and come back to cart screen
            await loadCartItems(emit);
          }
        }
      } else if (event is CartDeleteButtonClicked) {
        try {
          if (state is CartSuccess) {
            //show loading on the item that clicked
            final successSate = (state as CartSuccess);
            final cartItem = successSate.cartResponse.cartItems
                .firstWhere((cartItem) => cartItem.id == event.cartItemId);
            cartItem.deleteButtonLoading = true;
            emit(CartSuccess(successSate.cartResponse));
          }
          await cartRepository.delete(event.cartItemId);
          //update count
          await cartRepository.count();
          if (state is CartSuccess) {
            //remove item from list
            final successSate = (state as CartSuccess);
            successSate.cartResponse.cartItems
                .removeWhere((cartItem) => cartItem.id == event.cartItemId);
            if (successSate.cartResponse.cartItems.isEmpty) {
              emit(CartEmpty());
            } else {
              emit(calculatePriceInfo(successSate.cartResponse));
            }
          }
        } catch (e) {
          emit(CartError(AppException()));
        }
      } else if (event is IncreaseCountButtonClicked ||
          event is DecreaseCountButtonClicked) {
        try {
          int cartItemId = 0;
          if (event is IncreaseCountButtonClicked) {
            cartItemId = event.cartItemId;
          } else if (event is DecreaseCountButtonClicked) {
            cartItemId = event.cartItemId;
          }
          if (state is CartSuccess) {
            //show loading on the item that clicked
            final successSate = (state as CartSuccess);
            final index = successSate.cartResponse.cartItems
                .indexWhere((cartItem) => cartItem.id == cartItemId);
            successSate.cartResponse.cartItems[index].changeCountLoading = true;
            emit(CartSuccess(successSate.cartResponse));
            final newCount = event is IncreaseCountButtonClicked
                ? ++successSate.cartResponse.cartItems[index].count
                : --successSate.cartResponse.cartItems[index].count;

            await cartRepository.changeCount(cartItemId, newCount);
            //update count
            await cartRepository.count();
            successSate.cartResponse.cartItems
                .firstWhere((cartItem) => cartItem.id == cartItemId)
              ..count = newCount
              ..changeCountLoading = false;

            emit(calculatePriceInfo(successSate.cartResponse));
          }
        } catch (e) {
          emit(CartError(AppException()));
        }
      }
    });
  }
}

Future<void> loadCartItems(Emitter<CartState> emit) async {
  try {
    emit(CartLoading());
    final result = await cartRepository.getAll();
    if (result.cartItems.isEmpty) {
      emit(CartEmpty());
    } else {
      emit(CartSuccess(result));
    }
  } catch (e) {
    emit(CartError(AppException()));
  }
}

CartSuccess calculatePriceInfo(CartResponse cartResponse) {
  int totalPrice = 0;
  int payablePrice = 0;
  int shippingCost = 0;
  cartResponse.cartItems.forEach((cartItem) {
    totalPrice += cartItem.product.previousPrice * cartItem.count;
    payablePrice += cartItem.product.price * cartItem.count;
  });

  shippingCost = payablePrice >= 250000 ? 0 : 30000;

  cartResponse.totalPrice = totalPrice;
  cartResponse.payablePrice = payablePrice;
  cartResponse.shippingCost = shippingCost;

  return CartSuccess(cartResponse);
}
