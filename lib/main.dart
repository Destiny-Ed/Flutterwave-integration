import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterwave/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _amount = TextEditingController();

  String? _ref;

  void setRef() {
    Random rand = Random();
    int number = rand.nextInt(2000);

    if (Platform.isAndroid) {
      setState(() {
        _ref = "AndroidRef1789$number";
      });
    } else {
      setState(() {
        _ref = "IOSRef1789$number";
      });
    }
  }

  @override
  void initState() {
    setRef();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Wave Application")),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: _email,
                    decoration: InputDecoration(labelText: "Email"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: _amount,
                    decoration: InputDecoration(labelText: "Amount"),
                  ),
                ),
              ],
            ),
          ),

          ///Button
          Positioned(
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                final email = _email.text;
                final amount = _amount.text;

                if (email.isEmpty || amount.isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Field are empty")));
                } else {
                  ///Flutterwave Payment
                  _makePayment(context, email.trim(), amount.trim());
                }
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                color: Colors.lightBlue,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ///Icon
                      Icon(Icons.payment),

                      Text(
                        "Make Payment",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ]),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _makePayment(BuildContext context, String email, String amount) async {
    try {
      Flutterwave flutterwave = Flutterwave.forUIPayment(
          context: this.context,
          encryptionKey: "FLWSECK_TEST4734027149f5",
          publicKey: "FLWPUBK_TEST-e8d4cd5462fb381c4163ba7f7f746a98-X",
          currency: "NGN",
          amount: amount,
          email: "$email",
          fullName: "Destiny Ed",
          txRef: _ref!,
          isDebugMode: true,
          phoneNumber: "0123456789",
          acceptCardPayment: true,
          acceptUSSDPayment: true,
          acceptAccountPayment: true,
          acceptFrancophoneMobileMoney: false,
          acceptGhanaPayment: false,
          acceptMpesaPayment: true,
          acceptRwandaMoneyPayment: false,
          acceptUgandaPayment: false,
          acceptZambiaPayment: false);

      final ChargeResponse response =
          await flutterwave.initializeForUiPayments();

      if (response == null) {
        print("Transaction Failed");
      } else {
        ///
        if (response.status == "success") {
          print(response.data);
          print(response.message);

        } else {
          print(response.message);
        }
      }
    } catch (error) {
      print(error);
    }
  }
}
