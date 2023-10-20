// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

// void main() {
//   Stripe.publishableKey = 'YOUR_PUBLISHABLE_KEY';
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Stripe Payment Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ProductSelectionScreen(),
//     );
//   }
// }

// class Product {
//   final int id;
//   final String name;
//   final double price;

//   Product({
//     required this.id,
//     required this.name,
//     required this.price,
//   });
// }

// class ProductSelectionScreen extends StatefulWidget {
//   @override
//   _ProductSelectionScreenState createState() => _ProductSelectionScreenState();
// }

// class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
//   List<Product> availableProducts = [
//     Product(id: 1, name: 'Product A', price: 10.0),
//     Product(id: 2, name: 'Product B', price: 20.0),
//     // Add more products
//   ];

//   List<Product> selectedProducts = [];
//   Product? selectedDropdownProduct;

//   Future<void> _processPayment() async {
//     if (selectedProducts.isEmpty) {
//       return; // No products selected
//     }

//     try {
//       PaymentMethod paymentMethod = await Stripe.instance.paymentMethods.create(
//         PaymentMethodData.card(
//           number: '4242424242424242', // Replace with a valid test card number
//           expMonth: 12,
//           expYear: 25,
//           cvc: '123',
//         ),
//       );

//       double totalAmount = selectedProducts.map((product) => product.price).reduce((a, b) => a + b);

//       // Send paymentMethod.id and totalAmount to your server for processing
//       // Implement server-side logic to handle payment and fulfill the order
//     } catch (error) {
//       // Handle payment error
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Product Selection'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             DropdownButton<Product>(
//               value: selectedDropdownProduct,
//               onChanged: (newValue) {
//                 setState(() {
//                   selectedDropdownProduct = newValue;
//                 });
//               },
//               items: availableProducts.map((product) {
//                 return DropdownMenuItem<Product>(
//                   value: product,
//                   child: Text(product.name),
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 16.0),
//             Text('Selected Products:'),
//             ListView.builder(
//               shrinkWrap: true,
//               itemCount: availableProducts.length,
//               itemBuilder: (context, index) {
//                 final product = availableProducts[index];
//                 return CheckboxListTile(
//                   title: Text(product.name),
//                   value: selectedProducts.contains(product),
//                   onChanged: (checked) {
//                     setState(() {
//                       if (checked == true) {
//                         selectedProducts.add(product);
//                       } else {
//                         selectedProducts.remove(product);
//                       }
//                     });
//                   },
//                 );
//               },
//             ),
//             ElevatedButton(
//               onPressed: _processPayment,
//               child: Text('Proceed to Payment'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
