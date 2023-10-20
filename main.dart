import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stripe_payment_demo/demo/demo_video_screen.dart';

void main() {
  runApp(const MyApp());
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomeScreen(),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      home: VideoListPage(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.2)],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      childDecoration: const BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      drawer: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75, // Adjust the width as needed
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 64.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  // child: Image.asset(
                  //   'assets/images/flutter_logo.png',
                  // ),
                ),
                ListTile(
                  onTap: () {
                    _pageController.jumpToPage(0);
                    _advancedDrawerController.hideDrawer();
                  },
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                ),
                ListTile(
                  onTap: () {
                    _pageController.jumpToPage(1);
                    _advancedDrawerController.hideDrawer();
                  },
                  leading: const Icon(Icons.account_circle_rounded),
                  title: const Text('Profile'),
                ),
                ListTile(
                  onTap: () {
                    _pageController.jumpToPage(2);
                    _advancedDrawerController.hideDrawer();
                  },
                  leading: const Icon(Icons.favorite),
                  title: const Text('Favourites'),
                ),
                ListTile(
                  onTap: () {
                    _pageController.jumpToPage(3);
                    _advancedDrawerController.hideDrawer();
                  },
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                ),
                const Spacer(),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: const Text('Terms of Service | Privacy Policy'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: _currentPage == 0
              ? const Text('Advanced Drawer Example')
              : _currentPage == 1
                  ? const Text("Profile Screen")
                  : _currentPage == 2
                      ? const Text("Favourites Screen")
                      : const Text("Setting Screen"),
          leading: IconButton(
            onPressed: () {
              _advancedDrawerController.showDrawer();
            },
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: const [
            HomeContent(),
            ProfileScreen(),
            FavouritesScreen(),
            SettingsScreen(),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StaggeredGrid.count(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: [],
          ),
        ),
      ],
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: AppBar(
      //   title: const Text("Profile Screen"),
      // ),
      body: Center(
        child: Text(
          'Profile Content',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: AppBar(
      //   title: const Text("Favourites Screen"),
      // ),
      body: Center(
        child: Text(
          'Favourites Content',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: AppBar(
      //   title: const Text("Settings Screen"),
      // ),
      body: Center(
        child: Text(
          'Settings Content',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}










// // import 'package:flutter/material.dart';
// // import 'package:flutter_dotenv/flutter_dotenv.dart';
// // import 'package:flutter_stripe/flutter_stripe.dart';
// // import 'package:stripe_payment_demo/stripe_key.dart';

// // Future<void> main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   Stripe.publishableKey = "";
// //   Stripe.publishableKey = StripeUtils.stripePublishableKey;
// //   await Stripe.instance.applySettings();
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return const MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: MyHomePage(),
// //     );
// //   }
// // }

// // class MyHomePage extends StatefulWidget {
// //   const MyHomePage({super.key});

// //   @override
// //   State<MyHomePage> createState() => _MyHomePageState();
// // }

// // class _MyHomePageState extends State<MyHomePage> {
// //   CardFormEditController cardFormEditController = CardFormEditController();
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
// //         title: const Text('Stripe Payment'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(10.0),
// //         child: Column(
// //           children: <Widget>[
// //             CardFormField(
// //               controller: cardFormEditController,
// //               autofocus: true,
// //               onCardChanged: (card) {
// //                 cardFieldInputDetailsUpdate(card!);
// //               },
// //               style: CardFormStyle(
// //                 textColor: Colors.white,
// //                 // backgroundColor: Colors.grey
// //                 backgroundColor: const Color.fromARGB(255, 219, 216, 216),
// //               ),
// //             ),
// //             const SizedBox(height: 15),
// //             MaterialButton(
// //               color: Colors.blue,
// //               onPressed: () {
// //                 handleCreateTokenPress(
// //                   context: context,
// //                 );
// //               },
// //               child: Text("Submit"),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Future<void> handleCreateTokenPress(
// //       {required BuildContext context, int? livesCount}) async {
// //     try {
// //       const address = Address(
// //         city: 'SURAT',
// //         state: 'GJ',
// //         country: 'IN',
// //         line1: 'SURAT',
// //         line2: "SURAT",
// //         postalCode: '395010',
// //       );
// //       debugPrint("---------------------------------- ");
// //       final tokenData = await Stripe.instance.createToken(
// //         const CreateTokenParams(
// //           type: TokenType.Card,
// //           address: address,
// //         ),
// //       );
// //       debugPrint("???? ${tokenData.id}");
// //       if (tokenData != null) {
// //         debugPrint(tokenData.id);
// //       } else {}
// //       return;
// //     } catch (e) {
// //       debugPrint(e.toString());
// //     }
// //   }

// //   CardFieldInputDetails? card;
// //   cardFieldInputDetailsUpdate(CardFieldInputDetails value) {
// //     debugPrint('------------------------------------------');
// //     card = value;
// //     setState(() {});
// //     debugPrint(value.number);
// //     debugPrint(
// //         '${value.expiryMonth.toString()}/${value.expiryYear.toString()}');
// //     debugPrint(value.cvc);
// //   }
// // }

// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:stripe_payment_demo/card_expiry_text_field.dart';
// import 'package:stripe_payment_demo/in_app_purchase.dart';
// import 'package:stripe_payment_demo/make_payment_demo.dart';
// import 'package:stripe_payment_demo/new_in_app_screen.dart';
// import 'package:stripe_payment_demo/stripe_key.dart';
// import 'package:http/http.dart' as http;
// import 'package:awesome_card/awesome_card.dart';

// import 'package_inapp/package_code_in_app.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//  await Firebase.initializeApp();
//   Stripe.publishableKey = StripeUtils.stripePublishableKey;
//   // await Stripe.instance.applySettings();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: PackageScreen(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   CardFormEditController cardFormEditController = CardFormEditController();
//   List<Product> selectedProducts = [];
//   Product? selectedDropdownProduct;
//   Map<String, dynamic>? paymentIntent;
//   var tokenData;
//   Future<void> makePayment() async {
//     try {
//       paymentIntent = await createPaymentIntent("1000", 'INR');

//       var gpay = const PaymentSheetGooglePay(
//         merchantCountryCode: "IN",
//         currencyCode: "INR",
//         testEnv: true,
//       );

//       //STEP 2: Initialize Payment Sheet
//       await Stripe.instance
//           .initPaymentSheet(
//             paymentSheetParameters: SetupPaymentSheetParameters(
//               paymentIntentClientSecret:
//                   paymentIntent!['client_secret'], //Gotten from payment intent
//               style: ThemeMode.light,
//               merchantDisplayName: 'Abhi',
//               googlePay: gpay,
//             ),
//           )
//           .then((value) {});

//       //STEP 3: Display Payment sheet
//       displayPaymentSheet();
//     } catch (err) {
//       print(err);
//     }
//   }

//   displayPaymentSheet() async {
//     try {
//       print("---- DISPLAY PAYMENTSHEET ----");
//       await Stripe.instance.presentPaymentSheet().then((value) {
//         print("Payment Successfully");
//       });
//     } catch (e) {
//       print('$e');
//     }
//   }

//   createPaymentIntent(String amount, String currency) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': amount,
//         'currency': currency,
//       };

//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         headers: {
//           'Authorization': 'Bearer sk_test_GGEKwtIuIRjqzdNClfxZ6lBM00EVZiU6NH',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//         body: body,
//       );
//       return json.decode(response.body);
//     } catch (err) {
//       throw Exception(err.toString());
//     }
//   }

//   Map<String, dynamic>? paymentIntents;
//   final controller = CardFormEditController();
//   String cardNumber = 'XXXX XXXX XXXX XXXX';
//   String validDate = 'XX/XX';
//   final cardHolderNameEditingController = TextEditingController();
//   final bankNameEditingController = TextEditingController();
//   final cardNumberController = TextEditingController();
//   final validDateController = TextEditingController();
//   final cvvCodeController = TextEditingController();
//   String cvvCode = '';
//   cvvCodeUpdate(String value) {
//     cvvCode = value;
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Stripe Payment'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: <Widget>[
//             CreditCard(
//               cardNumber: cardNumberController.text,
//               cardExpiry: validDateController.text,
//               cardHolderName: cardHolderNameEditingController.text,
//               cvv: cvvCode,
//               bankName: bankNameEditingController.text,
//               cardType: CardType.masterCard,
//               frontBackground: CardBackgrounds.black,
//               backBackground: CardBackgrounds.white,
//               showShadow: true,
//               textExpDate: 'Exp. Date',
//               textName: 'Name',
//               textExpiry: 'MM/YY',
//             ),
//             CardFormField(
//               controller: controller,
//               countryCode: 'US',
//               style: CardFormStyle(
//                 borderColor: Colors.blueGrey,
//                 textColor: Colors.black,
//                 placeholderColor: Colors.blue,
//               ),
//             ),

//             const SizedBox(height: 20),
//             TextField(controller: cardHolderNameEditingController),
//             const SizedBox(height: 10),
//             TextField(controller: bankNameEditingController),
//             const SizedBox(height: 10),
//             TextField(
//               controller: cardNumberController,
//               keyboardType: TextInputType.number,
//               maxLength: 16,
//               decoration: const InputDecoration(hintText: "Card Number"),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: validDateController,
//               decoration: const InputDecoration(hintText: "Validate"),
//             ),
//             const SizedBox(height: 10),
//             CardExpiryTextField(controller: validDateController),
//             const SizedBox(height: 10),
//             TextField(
//               controller: cvvCodeController,
//               maxLength: 3,
//               decoration: const InputDecoration(hintText: "CVV Code"),
//               keyboardType: TextInputType.number,
//             ),

//             // DropdownButton<Product>(
//             //   value: selectedDropdownProduct,
//             //   onChanged: (newValue) {
//             //     setState(() {
//             //       selectedDropdownProduct = newValue;
//             //     });
//             //   },
//             //   items: availableProducts.map((product) {
//             //     return DropdownMenuItem<Product>(
//             //       value: product,
//             //       child: Text(product.name),
//             //     );
//             //   }).toList(),
//             // ),
//             // const SizedBox(height: 15),
//             // CheckboxListTile(
//             //   title: const Text('Additional Product A'),
//             //   value: selectedProducts
//             //       .contains(Product(id: 3, name: 'Product A', price: 300)),
//             //   onChanged: (checked) {
//             //     setState(() {
//             //       if (checked == true) {
//             //         selectedProducts
//             //             .add(Product(id: 3, name: 'Product A', price: 300));
//             //       } else {
//             //         selectedProducts
//             //             .remove(Product(id: 3, name: 'Product A', price: 300));
//             //       }
//             //     });
//             //   },
//             // ),
//             // CheckboxListTile(
//             //   title: const Text('Additional Product B'),
//             //   value: selectedProducts
//             //       .contains(Product(id: 4, name: 'Product B', price: 400)),
//             //   onChanged: (checked) {
//             //     setState(() {
//             //       if (checked == true) {
//             //         selectedProducts
//             //             .add(Product(id: 4, name: 'Product B', price: 400));
//             //       } else {
//             //         selectedProducts
//             //             .remove(Product(id: 4, name: 'Product B', price: 400));
//             //       }
//             //     });
//             //   },
//             // ),

//             MaterialButton(
//               color: Colors.blue,
//               onPressed: () async {
//                 // await processPayment();
//                 await processPayment();
//               },
//               child: const Text("Submit"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   calculateAmount(String amount) {
//     final calculatedAmout = (int.parse(amount)) * 100;
//     return calculatedAmout.toString();
//   }

//   Future<void> processPayment() async {
//     try {
//       // Create a token and handle the payment
//       tokenData = await Stripe.instance.createToken(
//         const CreateTokenParams.card(
//           params: CardTokenParams(
//             address: Address(
//               city: 'SURAT',
//               state: 'GJ',
//               country: 'IN',
//               line1: 'SURAT',
//               line2: 'SURAT',
//               postalCode: '395010',
//             ),
//             type: TokenType.Card,
//           ),
//         ),
//       );
//       debugPrint('Token Data: $tokenData');
//       // Handle the payment using the token data
//       _handlePayment(tokenData);
//     } catch (e) {
//       debugPrint('Error creating token: $e');
//     }
//   }

//   void _handlePayment(TokenData? tokenData) {
//     // Process the payment using the token data
//     if (tokenData != null) {
//       makePayment();
//       debugPrint('Token ID: ${tokenData.id}');
//     } else {
//       debugPrint('Token creation failed');
//     }
//   }

//   // Future<void> handleCreateTokenPress(
//   //     {required BuildContext context, int? livesCount}) async {
//   //   try {
//   //     // Combine selected products into a single list
//   //     List<Product> allSelectedProducts = [];
//   //     if (selectedDropdownProduct != null) {
//   //       allSelectedProducts.add(selectedDropdownProduct!);
//   //     }
//   //     allSelectedProducts.addAll(selectedProducts);

//   //     // Calculate total amount based on selected products
//   //     double totalAmount = allSelectedProducts
//   //         .map((product) => product.price)
//   //         .reduce((a, b) => a + b);
//   //   } catch (e) {
//   //     debugPrint(e.toString());
//   //   }
//   // }
// }

// class Product {
//   final int id;
//   final String name;
//   final double price;
//   Product({required this.id, required this.name, required this.price});

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Product && runtimeType == other.runtimeType && id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// // Define your availableProducts list here
// List<Product> availableProducts = [
//   Product(id: 1, name: 'Product A', price: 100),
//   Product(id: 2, name: 'Product B', price: 200),
// ];
