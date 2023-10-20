import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class Product {
  final String id;
  final String name;
  final int price;

  Product({required this.id, required this.name, required this.price});
}

class DemoHomeScreen extends StatefulWidget {
  const DemoHomeScreen({Key? key}) : super(key: key);

  @override
  _DemoHomeScreenState createState() => _DemoHomeScreenState();
}

class _DemoHomeScreenState extends State<DemoHomeScreen> {
  Map<String, dynamic>? paymentIntent;
  List<Product> selectedProducts = [];
  Product? selectedDropdownProduct;
  List<Product> availableProducts = [
    Product(id: '1', name: 'Product A', price: 10 *100),
    Product(id: '2', name: 'Product B', price: 20 *100),
    Product(id: '3', name: 'Product C', price: 15 * 100),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DropdownButton<Product>(
              value: selectedDropdownProduct,
              onChanged: (product) {
                setState(() {
                  selectedDropdownProduct = product;
                });
              },
              items: availableProducts
                  .map<DropdownMenuItem<Product>>((Product product) {
                return DropdownMenuItem<Product>(
                  value: product,
                  child: Text(product.name),
                );
              }).toList(),
            ),
            Column(
              children: availableProducts
                  .where((product) => product != selectedDropdownProduct)
                  .map((product) => CheckboxListTile(
                        title: Text(product.name),
                        value: selectedProducts.contains(product),
                        onChanged: (selected) {
                          setState(() {
                            if (selected!) {
                              selectedProducts.add(product);
                            } else {
                              selectedProducts.remove(product);
                            }
                          });
                        },
                      ))
                  .toList(),
            ),
            TextButton(
              child: const Text('Buy Now'),
              onPressed: () async {
                if (selectedDropdownProduct != null ||
                    selectedProducts.isNotEmpty) {
                  await makePayment();
                } else {
                  // Handle case when no products are selected
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String calculateTotalPrice() {
    int total = 0;
    if (selectedDropdownProduct != null) {
      total += selectedDropdownProduct!.price;
    }
    for (Product product in selectedProducts) {
      total += product.price;
    }
    return total.toString();
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent(calculateTotalPrice(), 'INR');

      var gpay = const PaymentSheetGooglePay(
        merchantCountryCode: "IN",
        currencyCode: "INR",
        testEnv: true,
      );

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret:
                  paymentIntent!['client_secret'], //Gotten from payment intent
              style: ThemeMode.light,
              merchantDisplayName: 'Abhi',
              googlePay: gpay,
            ),
          )
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet() async {
    try {
      print("---- DISPLAY PAYMENTSHEET ----");
      await Stripe.instance.presentPaymentSheet().then((value) {
        print("Payment Successfully");
      });
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer sk_test_GGEKwtIuIRjqzdNClfxZ6lBM00EVZiU6NH',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
