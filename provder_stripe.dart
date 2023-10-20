// // ignore_for_file: deprecated_member_use, use_build_context_synchronously

// import 'dart:convert';
// import 'dart:html';
// import 'package:either_dart/either.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';


// class PaymentScreenProvider extends ChangeNotifier {
//   final TextEditingController cardHolderNameEditingController =
//       TextEditingController();
//   final TextEditingController bankNameEditingController =
//       TextEditingController();

//   // bool _isShowBackView = false;
//   // bool get isShowBackView => _isShowBackView;
//   // set isShowBackView(bool value) {
//   //   _isShowBackView = value;
//   //   notifyListeners();
//   // }

//   CardFieldInputDetails? card;
//   cardFieldInputDetailsUpdate(CardFieldInputDetails value) {
//     debugPrint('------------------------------------------');
//     card = value;
//     notifyListeners();
//     debugPrint(value.number);
//     debugPrint(
//         '${value.expiryMonth.toString()}/${value.expiryYear.toString()}');
//     debugPrint(value.cvc);

//     // if (card!.number!.isNotEmpty) {
//     //   cardNumberUpdate(card!.number!);
//     // }
//     // if (card!.expiryMonth != null) {
//     //   expiryDateUpdate(card!.expiryMonth.toString());
//     // }
//     // if (card!.expiryYear != null) {
//     //   expiryDateUpdate('${card!.expiryMonth.toString()}/${card!.expiryYear.toString()}');
//     // }

//     // if (card!.cvc!.isNotEmpty) {
//     //   cvvCodeUpdate(card!.cvc!);
//     // }

//     // cvvCodeUpdate(card!.cvc!);
//   }

//   String cvvCode = '';
//   cvvCodeUpdate(String value) {
//     cvvCode = value;
//     notifyListeners();
//   }

//   String cardNumber = 'XXXX XXXX XXXX XXXX';
//   cardNumberUpdate(String value) {
//     var text = value;

//     var buffer = StringBuffer();
//     for (int i = 0; i < text.length; i++) {
//       buffer.write(text[i]);
//       var nonZeroIndex = i + 1;
//       if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
//         buffer.write(' ');
//       }
//     }

//     var string = buffer.toString();
//     cardNumber = string;
//     notifyListeners();
//   }

//   String validDate = 'XX/XX';
//   expiryDateUpdate(String value) {
//     var text = value;

//     var buffer = StringBuffer();
//     for (int i = 0; i < text.length; i++) {
//       buffer.write(text[i]);
//       var nonZeroIndex = i + 1;
//       if (nonZeroIndex % 2 == 0 && nonZeroIndex != text.length) {
//         buffer.write('/');
//       }
//     }

//     var string = buffer.toString();
//     validDate = string;
//     notifyListeners();
//   }

//   Future<void> handleCreateTokenPress(
//       {required BuildContext context, required int livesCount}) async {
//     try {
//  var token = await Stripe.instance.createToken(
//       const CreateTokenParams.card(
//         params: CardTokenParams(
//           name: "test",
//           address: Address(
//             line1: "abc",
//             line2: "xyz",
//             city: "Alpha",
//             state: "Beta",
//             country: "xy",
//             postalCode: "237482",
//           ),
//           currency: "ab",
//           type: TokenType.Card,
//         ),
//       ),
//     );
//     print("${token.id}");

//       const address = Address(
//         city: 'SURAT',
//         state: 'GJ',
//         country: 'IN',
//         line1: 'SURAT',
//         line2: "SURAT",
//         postalCode: '395010',
//       );
//       debugPrint("---------------------------------- ");
//       paymentResponseData = Right(NoDataFoundException());
//       final tokenData = await Stripe.instance.createToken(
//         const CreateTokenParams(type: TokenType.Card, address: address),
//       );
//       debugPrint("???? ${tokenData.id}");
//       if (tokenData != null) {
//         debugPrint(tokenData.id);
//         makePayment(
//             context: context,
//             stripeToken: tokenData.id,
//             livesCount: livesCount);
//       } else {
//         paymentResponseData = Right(SuccessResultException());
//       }
//       return;
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }

//   Either<PaymentResponse, Exception> _paymentResponseData =
//       Right(SuccessResultException());
//   Either<PaymentResponse, Exception> get paymentResponseData =>
//       _paymentResponseData;
//   set paymentResponseData(Either<PaymentResponse, Exception> value) {
//     _paymentResponseData = value;
//     notifyListeners();
//   }

//   makePayment(
//       {required String stripeToken,
//       required int livesCount,
//       required BuildContext context}) async {
//     final navigator = Navigator.of(context);
//     paymentResponseData = Right(NoDataFoundException());
//     Either<PaymentResponse, Exception> loginResponse = await paymentApi(
//         context: context,
//         email: userResponse.email!,
//         stripeToken: stripeToken,
//         livesCount: livesCount.toString(),
//         userId: userResponse.id.toString());

//     if (loginResponse.isLeft) {
//       paymentResponseData = Right(SuccessResultException());
//       if (loginResponse.left.status == AlertMsgUtils.response0Status) {
//         motionToastWidget(
//             context: context, toastMsg: loginResponse.left.msg ?? "");
//       } else {
//         userResponse.noOfLives = userResponse.noOfLives + livesCount;
//         await StorageUtils.writeStringValue(
//             key: StorageKeyUtils.userResponse, value: jsonEncode(userResponse));
//         userResponse = await GetResponse().getUserResponse();
//         motionToastWidget(
//             context: context,
//             toastMsg: loginResponse.left.msg!,
//             motionType: MotionToastType.success);
//         navigator.pop();
//       }
//     } else {
//       paymentResponseData = Right(SuccessResultException());
//       if (loginResponse.right is NoDataFoundException) {
//         paymentResponseData = Right(NoDataFoundException());
//         NoDataFoundException().showNoDataWidget(
//           context: context,
//           onCancelTap: () {
//             Navigator.pop(context);
//             paymentResponseData = Right(SuccessResultException());
//           },
//           onRetryTap: () {
//             Navigator.pop(context);
//             makePayment(
//                 context: context,
//                 livesCount: livesCount,
//                 stripeToken: stripeToken);
//           },
//         );
//       }
//     }
//   }

//   UserResponse userResponse = UserResponse();
//   getUserData({bool isFromInit = false}) async {
//     userResponse = await GetResponse().getUserResponse();
//     cardHolderNameEditingController.text = userResponse.fullName ?? '';
//     bankNameEditingController.clear();
//     notifyListeners();
//   }
// }
