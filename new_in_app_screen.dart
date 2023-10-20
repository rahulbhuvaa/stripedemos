import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class NewInAppScreen extends StatefulWidget {
  const NewInAppScreen({super.key});

  @override
  State<NewInAppScreen> createState() => _NewInAppScreenState();
}

class _NewInAppScreenState extends State<NewInAppScreen> {
  final List<String> productId = ['product_one', 'product_two'];
  List<ProductDetails> productsList = [];
  List<String> selectedProducts = [];
  bool isProductSelectOne = false;
  bool isProductSelectTwo = false;
  List<String> kConsumableId = [];
 String kSubscriptionId = '';
  List<String>? _kAndroidProductIds; // Please Add your android product ID here
  List<String>? _kiOSProductIds; // Please Add your iOS product ID here
  late PurchaseParam purchaseParam;
  ProductDetails? productDetailsParam;
  StreamSubscription<List<PurchaseDetails>>? subscription;
  List<String> notFoundIds = [];
  List<ProductDetails> products = [];
  List<PurchaseDetails> purchases = [];
  List<String> _consumables = [];
  bool _isAvailable = false;
  bool purchasePending = false;
  bool loading = false;
  String? queryProductError;
  bool purchaseAds = false;
  bool isProductSelect = false;


  final InAppPurchase connection = InAppPurchase.instance;

@override
  void initState() {
    super.initState();
    initStoreInfo();
        _kAndroidProductIds = productId;
    _kiOSProductIds = productId;
    kConsumableId.addAll(productId ?? []);
  }

    Future<void> initStoreInfo() async {
    final bool isAvailable = await connection.isAvailable();

    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        products = [];
        purchases = [];
        notFoundIds = [];
        _consumables = [];
        purchasePending = false;
        loading = false;
      });
      return;
    }

    debugPrint("object... ${products.length}");
    setState(() {});

    ///commented
    ProductDetailsResponse productDetailResponse =
        await connection.queryProductDetails(
      Platform.isIOS ? _kiOSProductIds!.toSet() : _kAndroidProductIds!.toSet(),
    ); //_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        products = productDetailResponse.productDetails;
        purchases = [];
        notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        purchasePending = false;
        loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        queryProductError = null;
        _isAvailable = isAvailable;
        products = productDetailResponse.productDetails;
        purchases = [];
        notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        purchasePending = false;
        loading = false;
      });
      return;
    }

    List<String> consumables = [];

    ///commented
    setState(() {
      _isAvailable = isAvailable;
      products = productDetailResponse.productDetails;
      notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      purchasePending = false;
      loading = false;
      purchaseParam = PurchaseParam(
          productDetails: products.first, applicationUserName: null);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ListTile(
            title: const Text("Product One",
                style: TextStyle(fontSize: 18, color: Colors.deepPurpleAccent)),
            subtitle: const Text("For TEsting Product One"),
            leading: const Text("\$0.99",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            trailing: Checkbox(
              value: isProductSelectOne,
              onChanged: (value) {
                isProductSelectOne = !isProductSelectOne;
                setState(() {
                  if (isProductSelectOne) {
                    selectedProducts.remove(productId[0]);
                  } else {
                    selectedProducts.add(productId[0]);
                  }
                });
              },
            ),
            onTap: () {
              
            },
          ),
          const SizedBox(height: 20),
          ListTile(
            title: const Text("Product Two",
                style: TextStyle(fontSize: 18, color: Colors.deepPurpleAccent)),
            subtitle: const Text("For TEsting Product Two"),
            leading: const Text("\$5.00",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            trailing: Checkbox(
              value: isProductSelectTwo,
              onChanged: (value) {
                isProductSelectTwo = !isProductSelectTwo;
                setState(() {
                  if (isProductSelectTwo) {
                    selectedProducts.remove(productId[1]);
                  } else {
                    selectedProducts.add(productId[1]);
                  }
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          MaterialButton(
            color: Colors.pink,
            height: 54,
            minWidth: double.infinity,
            child: const Text('Purchase'),
            onPressed: () async {
              // if (selectedProduct.isNotEmpty) {
              //   for (var product in selectedProduct) {
              //   final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
              //   await connection.buyNonConsumable(purchaseParam: purchaseParam);

              //   }
              // } else {
              //   print("Product Not Selected");
              // }
            },
          ),
        ],
      ),
    );
  }
}
