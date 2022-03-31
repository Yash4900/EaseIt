import 'package:ease_it/firebase/database.dart';
import 'package:ease_it/utility/globals.dart';
import 'package:ease_it/utility/toast.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPay extends StatefulWidget {
  final String month, billAmount;
  RazorPay({this.month, this.billAmount });
  @override
  _RazorPayState createState() => _RazorPayState();
}

class _RazorPayState extends State<RazorPay> {
  Globals g = Globals();
  Razorpay _razorpay;  

  @override
  void initState() {
    super.initState();
    _razorpay = new Razorpay();  
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckOut() {
    var options = {
      'key': 'rzp_test_x6c7Awv9gO6JkK',
      'amount': num.parse(widget.billAmount)*100, //in the smallest currency sub-unit.
      'name': 'Ease It',
      // 'order_id': 'order_EMBFqjDHEEn80l', // Generate order_id using Orders API
      'description': 'Maintenance Bill of ${g.fname} ${g.lname}, residing in ${g.society} ${g.flat["Wing"]}-${g.flat["Flat"]} for ${widget.month}',
      'timeout': 180, // in seconds
      'prefill': {
        'contact': g.phoneNum,
        'email': g.email
      }
    };
    try {
      _razorpay.open(options);
    }
    catch(e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Database()
      .markMaintenanceAsPaid(
        g.society,
        g.flat["Wing"],
        g.flat["Flat"],
        widget.month,
        widget.billAmount
        )
      .then((value) {
    showToast(context, "success", "Success",
        "Maintenance for ${widget.month} Paid Successfully");
    Navigator.pop(context);
    }).catchError((onError) {
      showToast(
          context, "error", "Error", onError.toString());
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    showToast(context, "Failure", "Failure",
        "Maintenance Payment Failed. Please Try Again Later");
    Navigator.pop(context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    showToast(context, "Failure", "Failure",
        "This Payment Method is currently unavailable");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leadingWidth: MediaQuery.of(context).size.width * 0.3,
        backgroundColor: Colors.white,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Row(
            children: [
              Icon(Icons.keyboard_backspace, color: Colors.black),
              SizedBox(width: 5),
              Text(
                'Back',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Text(
              'Maintenance Bill Payment',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'Kindly verify the details below and then click on Pay',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Month',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  widget.month,
                  style: TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 14),
                ),
                SizedBox(height: 20),
                Text(
                  'Bill Amount',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  widget.billAmount,
                  style: TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 14),
                ),
                SizedBox(height: 50),
                Center(
                  child: TextButton(
                    onPressed: () {
                      openCheckOut();                             
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30, vertical: 3),
                      child: Text(
                        'Pay',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xff037DD6)),
                      shape: MaterialStateProperty.all<
                          RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),                  
          ],
        ),
      ),
    );
  }
} 