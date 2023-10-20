import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

const bool kAutoConsume = true;
List<String> _kConsumableId = [];
const String _kSubscriptionId = '';
final List<String> productId = ['product_one', 'product_two'];  // this is testing id 

class InAppScreen extends StatefulWidget {
  const InAppScreen({super.key});

  @override
  State<InAppScreen> createState() => _InAppScreenState();
}

class _InAppScreenState extends State<InAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const InAppPurchasesScreen(),
    );
  }
}

class InAppPurchasesScreen extends StatefulWidget {
  const InAppPurchasesScreen({Key? key}) : super(key: key);
  @override
  _InAppPurchasesScreenState createState() => _InAppPurchasesScreenState();
}

class _InAppPurchasesScreenState extends State<InAppPurchasesScreen> {
  List<String>? _kAndroidProductIds; // Please Add your android product ID here
  List<String>? _kiOSProductIds; // Please Add your iOS product ID here
  late PurchaseParam purchaseParam;
  ProductDetails? productDetailsParam;
  final InAppPurchase _connection = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = false;
  String? _queryProductError;
  bool purchaseAds = false;
  bool isProductSelect = false;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      initStoreInfo();
    });
    _kAndroidProductIds = productId;
    _kiOSProductIds = productId;
    _kConsumableId.addAll(productId ?? []);
    Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription?.cancel();
    }, onError: (error) {
      // handle error here.
    }) as StreamSubscription<List<PurchaseDetails>>?;
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _connection.isAvailable();

    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    debugPrint("object... ${_products.length}");
    setState(() {});

    ///commented
    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(
      Platform.isIOS ? _kiOSProductIds!.toSet() : _kAndroidProductIds!.toSet(),
    ); //_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    List<String> consumables = [];

    ///commented
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
      purchaseParam = PurchaseParam(
          productDetails: _products.first, applicationUserName: null);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  bool isSelected = false;
  int planSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> stack = [];
    if (_queryProductError == null) {
      stack.add(
        Center(
          child: ListView(
            children: [
              _buildProductList(),
            ],
          ),
        ),
      );
    } else {
      stack.add(Center(
        child: Text(_queryProductError ?? ""),
      ));
    }
    if (_purchasePending) {
      stack.add(
        const Stack(
          children: [
            Opacity(
              opacity: 0.3,
              child: ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          children: stack,
        ),
      ),
    );
  }

  Widget _buildProductList() {
    if (_loading) {
      return const Align(
        alignment: FractionalOffset(0.5, 0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
          ],
        ),
      );
    }
    if (!_isAvailable) {
      return const Card();
    }

    List<Widget> productList = <Widget>[];

    _products.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
    productList.addAll(_products.map(
      (ProductDetails productDetails) {
        debugPrint("😆🤣🙃😗😋😍😊${productDetails.id}");
        // debugPrint("INDEX --->>>>>>>>${_products.indexOf(productDetails)}");
        return SelectPlanFieldWidget(
          offerText: productDetails.title,
          price: productDetails.price,
          isSelected: planSelectedIndex == _products.indexOf(productDetails),
          onTap: () {
            productDetailsParam = productDetails;
            purchaseParam = PurchaseParam(
              productDetails: productDetails,
              applicationUserName: null,
            );
            planSelectedIndex = _products.indexOf(productDetails);
            // print("planSelectedIndex --->>> $planSelectedIndex");
            setState(() {});
          },
        );
      },
    ));

    return SingleChildScrollView(
      child: Column(
        children: [
          productList.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    "No purchase lives found",
                  ),
                )
              : Column(children: <Widget>[] + productList),
          const SizedBox(width: 20),
          Visibility(
            visible: productList.isEmpty == true ? false : true,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: MaterialButton(
                color: Colors.black26,
                height: 54,
                child: const Text('Purchase'),
                onPressed: () {
                  debugPrint("Object ID ------->>>>>>>>> ${purchaseParam.productDetails.id}");

                  if (_kConsumableId.contains(productDetailsParam?.id)) {
                    debugPrint("in the if condition");
                    _connection.buyConsumable(purchaseParam: purchaseParam);
                  } else {
                    debugPrint("in the else condition");
                    _connection.buyNonConsumable(purchaseParam: purchaseParam);
                  }
                  _loading = false;
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    debugPrint('deliverProduct'); // Last  ------- This is final payment
    if (_kConsumableId.contains(purchaseDetails.productID)) {
      List<String> consumables = [];
      setState(() {
        _purchasePending = false;
        _consumables = consumables;
      });
    } else {
      setState(() {
        _purchases.add(purchaseDetails);
        _purchasePending = false;
      });
    }
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    debugPrint('_verifyPurchase');
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    debugPrint('_handleInvalidPurchase');
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    debugPrint('_listenToPurchaseUpdated');
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _loading = false;
        setState(() {});
        showPendingUI();
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
        _loading = false;
        _purchasePending = false;
        setState(() {
          debugPrint("object value $_loading");
        });
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          debugPrint("object.... ${purchaseDetails.productID}");
          debugPrint("true>>>>>>error  ${purchaseDetails.error}");
          handleError(purchaseDetails.error ??
              IAPError(source: '', code: '', message: ''));
          _loading = false;
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            // String? value = await getDeviceId();

            log("objectvalue?????? ${purchaseDetails.verificationData.serverVerificationData}");
            debugPrint(
                "objectvalue??????debugPrint---->>>> ${purchaseDetails.verificationData.serverVerificationData}");
            deliverProduct(purchaseDetails);
            // pref.setBool("purchaseAds", true);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!kAutoConsume &&
              _kConsumableId.contains(purchaseDetails.productID)) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                _connection.getPlatformAddition<
                    InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  Future<String> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    late String deviceId;
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor!;
      debugPrint("😃😀😁😆😅😄<><><>iOS<><><>😃😀😁😆😅😄---->>>>>>$deviceId");
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.id;
      debugPrint(
          "😃😀😁😆😅😄<><><>ANDROID<><><>😃😀😁😆😅😄---->>>>>>$deviceId");
    } else {
      debugPrint(
          "OPPSS................................................................................");
      deviceId = 'null';
    }
    return deviceId;
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}

class SelectPlanFieldWidget extends StatelessWidget {
  final String? offerText;
  final String? price;
  final bool? isSelected;
  final VoidCallback? onTap;

  const SelectPlanFieldWidget({
    Key? key,
    this.offerText = '',
    this.price = '',
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black12,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 18,
                    width: 18,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.black, width: 2),
                        shape: BoxShape.circle),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isSelected!
                            ? Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    color: Colors.blue, shape: BoxShape.circle),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(offerText!),
                  const Spacer(),
                  const SizedBox(width: 15),
                  Text(price!),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
