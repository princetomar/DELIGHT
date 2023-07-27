import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final String name;
  const PaymentScreen({super.key, required this.name});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // create razorpay instance
  var _razorpay = Razorpay();

  // For razorpay listeners
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.purpleAccent,
            title: Column(
              children: [
                const Text(
                  'Payment Successful',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Payment ID: ${response.paymentId}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.purpleAccent,
            title: Column(
              children: [
                const Text(
                  'Payment Failed',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Payment ID: ${response.error}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.purpleAccent,
            title: Column(
              children: [
                const Text(
                  'Payment External Wallet',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Payment ID: ${response.walletName}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    amountController = TextEditingController(text: 100.toString());
    super.initState();
  }

  late TextEditingController amountController;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/images/delight_name.png",
                  height: size.height * 0.27,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  'Get One Gift Card',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  '@  ₹100',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.2),
              child: TextField(
                controller: amountController,
                decoration: InputDecoration(
                  hintText: "Enter Amount",
                  hintStyle: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.w400,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.06,
            ),
            TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.3, vertical: size.height * 0.02),
              ),
              onPressed: () {
                var options = {
                  'key': "rzp_live_wIkdR9oFcKOMew",
                  'amount': (int.parse(amountController.text) * 100).toString(),
                  'name': 'DELIGHT',
                  'description': 'Get One Gift Card',
                  'timeout': 120,
                  'prefill': {
                    'contact': '123125743',
                    'email': 'demoaccount123@gmail.com'
                  }
                };
                _razorpay.open(options);
              },
              child: Text(
                'Pay'.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _razorpay.clear();
    amountController.dispose();
    super.dispose();
  }
}
