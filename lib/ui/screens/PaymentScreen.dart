import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:peterjustesen/core/constants/constants.dart';
import 'package:peterjustesen/core/services/notificationsApi.dart';
import 'package:peterjustesen/core/services/paymentService.dart';
import 'package:peterjustesen/ui/screens/OrderDoneScreen.dart';
import 'package:peterjustesen/ui/widgets/AddToCartCard.dart';
import 'package:peterjustesen/ui/widgets/PeterAppBar.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PaymentScreen extends StatefulWidget {
  String? name;
  String? email;
  String? phone;
  String? address;
  num? total;

  PaymentScreen({super.key, required this.name, required this.email, required this.phone, required this.address, required this.total});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _numberController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  var subscription;

  // var subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
  //   if (result == ConnectivityResult.none) {
  //     Fluttertoast.showToast(msg: "No Internet Connection");
  //   }
  // });

  @override
  dispose() {
    super.dispose();

    subscription.cancel();
  }

  @override
  void initState() {
    super.initState();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Network Issue'),
                content:
                Text('Internet connection is not avialble! try later.'),
                actions: [
                  TextButton(onPressed: () {
                    print('work');
                    Navigator.pop(context);
                  }, child: Text('Cancel'))
                ],
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PeterAppBar(title: "Payment"),
      body: Center(
        child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(23),
              child: VStack(crossAlignment: CrossAxisAlignment.center, [
                StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? Container()
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.data()!["cart"].length,
                              itemBuilder: (context, index) {
                                return StreamBuilder(
                                    stream: FirebaseFirestore.instance.collection("products").doc(snapshot.data!.data()!["cart"][index]["uid"]).snapshots(),
                                    builder: (context, product_snapshot) {
                                      return product_snapshot.connectionState == ConnectionState.waiting
                                          ? AddToCartCard(
                                              title: "Product",
                                              image:
                                                  "https://firebasestorage.googleapis.com/v0/b/peterjustesen-37e4f.appspot.com/o/product_images%2F961c969b-d709-4724-8de5-bb8831852e49.png?alt=media&token=8600a64e-c34a-425a-95a4-d3719ead0541",
                                              price: "",
                                              quantity: 1,
                                              variant: [],
                                              id: "",
                                              productId: "",
                                              index: 0,
                                              context: context)
                                          : AddToCartCard(
                                              id: snapshot.data!.data()!["cart"][index]["id"],
                                              productId: snapshot.data!.data()!["cart"][index]["uid"],
                                              quantity: snapshot.data!.data()!["cart"][index]["amount"],
                                              variant: snapshot.data!.data()!["cart"][index]["variant"],
                                              index: index,
                                              title: product_snapshot.data!.data()!["title"],
                                              image: product_snapshot.data!.data()!["thumbnail"][0],
                                              price: product_snapshot.data!.data()!["price"],
                                              isCheckout: true,
                                              hasSubTitle: true,
                                              subTitle:
                                                  "${product_snapshot.data!.data()!["description"].length > 30 ? product_snapshot.data!.data()!["description"].substring(0, 30) : product_snapshot.data!.data()!["description"]}...",
                                              context: context,
                                            );
                                    });
                              },
                            );
                    }),
                22.heightBox,
                SizedBox(
                  height: 174.h,
                  width: 350.w,
                  child: VStack([
                    Text(
                      "Card number",
                      style: custom_montserratTextTheme.button!.copyWith(color: Color(0xff999cA0), fontWeight: FontWeight.w500, fontSize: 13.sp),
                    ),
                    SizedBox(
                        height: 22.h,
                        // margin: EdgeInsets.all(12),
                        child: TextFormField(
                          controller: _numberController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(16),
                            MaskTextInputFormatter(mask: '####  ####  ####  ####', filter: {"#": RegExp(r'[0-9]')})
                          ],
                          keyboardType: TextInputType.number,
                          // maxLines: 20.h ~/ 20,
                          // add space every 4 digits
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff999cA0)),
                            ),
                          ),
                          style: custom_montserratTextTheme.displaySmall!.copyWith(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12.sp),
                        )),
                    27.h.heightBox,
                    Text(
                      "Cardholder name",
                      style: custom_montserratTextTheme.button!.copyWith(color: Color(0xff999cA0), fontWeight: FontWeight.w500, fontSize: 13.sp),
                    ),
                    SizedBox(
                        height: 20.h,
                        // margin: EdgeInsets.all(12),
                        child: TextFormField(
                          controller: _nameController,
                          // maxLines: 20.h ~/ 20,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff999cA0)),
                            ),
                          ),
                          style: custom_montserratTextTheme.displaySmall!.copyWith(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12.sp),
                        )),
                    HStack([
                      Expanded(
                        child: VStack([
                          27.h.heightBox,
                          Text(
                            "Expiry date",
                            style: custom_montserratTextTheme.button!.copyWith(color: Color(0xff999cA0), fontWeight: FontWeight.w500, fontSize: 13.sp),
                          ),
                          SizedBox(
                              height: 20.h,
                              // margin: EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _monthController,
                                      // maxLines: 20.h ~/ 20,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(2),
                                      ],
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: "MM",

                                        hintStyle: custom_montserratTextTheme.displaySmall!.copyWith(color: Color(0xff999cA0), fontWeight: FontWeight.w300, fontSize: 12.sp),
                                        // contentPadding: const EdgeInsets.symmetric(
                                        // vertical: 30, horizontal: 10),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xff999cA0)),
                                        ),
                                      ),
                                      style: custom_montserratTextTheme.displaySmall!.copyWith(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12.sp),
                                    ),
                                  ),
                                  10.w.widthBox,
                                  Expanded(
                                    child: TextField(
                                      controller: _yearController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(2),
                                      ],
                                      // maxLines: 20.h ~/ 20,
                                      decoration: InputDecoration(
                                        hintText: "YY",
                                        hintStyle: custom_montserratTextTheme.displaySmall!.copyWith(color: Color(0xff999cA0), fontWeight: FontWeight.w300, fontSize: 12.sp),
                                        // contentPadding: const EdgeInsets.symmetric(
                                        // vertical: 30, horizontal: 10),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xff999cA0)),
                                        ),
                                      ),
                                      style: custom_montserratTextTheme.displaySmall!.copyWith(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12.sp),
                                    ),
                                  ),
                                ],
                              )),
                        ]),
                      ),
                      10.w.widthBox,
                      Expanded(
                        child: VStack([
                          27.h.heightBox,
                          Text(
                            "CVV",
                            style: custom_montserratTextTheme.button!.copyWith(color: Color(0xff999cA0), fontWeight: FontWeight.w500, fontSize: 13.sp),
                          ),
                          SizedBox(
                              height: 20.h,
                              child: TextField(
                                controller: _cvvController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                // maxLines: 20.h ~/ 20,
                                decoration: InputDecoration(
                                  hintText: "XXX",
                                  // contentPadding: const EdgeInsets.symmetric(
                                  // vertical: 30, horizontal: 10),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff999cA0)),
                                  ),
                                ),
                                style: custom_montserratTextTheme.displaySmall!.copyWith(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12.sp),
                              )),
                        ]),
                      ),
                    ])
                  ]).box.sizePCT(context: context, heightPCT: .2, widthPCT: .2).make(),
                ).p24().scrollVertical().box.color(Colors.white).rounded.outerShadow2Xl.make().pSymmetric(h: 16.w, v: 16.h),
                22.heightBox,
                callToActionButton(
                    width: .8.sw,
                    text: "Pay Now",
                    onPressed: () async {
                      EasyLoading.dismiss();
                      if (_nameController.text.isEmpty) {
                        Fluttertoast.showToast(msg: "Please enter cardholder name");
                        return;
                      }
                      if (_numberController.text.isEmpty) {
                        Fluttertoast.showToast(msg: "Please enter card number");
                        return;
                      }
                      if (_numberController.text.isNotEmpty && _numberController.text.replaceAll(' ', '').length != 16 ) {
                        Fluttertoast.showToast(msg: "Please enter 16 digit card number");
                        return;
                      }
                      if (_monthController.text.isEmpty) {
                        Fluttertoast.showToast(msg: "Please enter expiry month");
                        return;
                      }
                      if(_monthController.text.isNotEmpty && ((int.parse(_monthController.text) < 1) || (int.parse(_monthController.text) > 12))){
                        Fluttertoast.showToast(msg: "Please enter expiry month greater then 0 and less then 12");
                        return;
                      }
                      if (_yearController.text.isEmpty) {
                        Fluttertoast.showToast(msg: "Please enter expiry year");
                        return;
                      }
                      if(_yearController.text.isNotEmpty && int.parse(_yearController.text) <= int.parse(DateTime.now().year.toString().substring(2, DateTime.now().year.toString().length))){
                        Fluttertoast.showToast(msg: "Please enter expiry year greater then ${DateTime.now().year}");
                        return;
                      }
                      if (_cvvController.text.isEmpty) {
                        Fluttertoast.showToast(msg: "Please enter cvv}");
                        return;
                      }
                      EasyLoading.show(status: "Processing...");

                      var data = {
                        'number': _numberController.text.replaceAll(' ', ''),
                        'exp_month': _monthController.text,
                        'exp_year': _yearController.text,
                        'cvc': _cvvController.text,
                        'amount': ((widget.total!).round() * 100).toString()
                      };

                      var msg = await PaymentService.sendPayment(data);
                      print(msg);

                      if(msg['success'] == true){
                        var cart = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) => value.data()!["cart"]);
                        var total_amount =
                        await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) => value.data()!["total_amount"]);

                        await FirebaseFirestore.instance.collection("orders").doc().set({
                          "uid": FirebaseAuth.instance.currentUser!.uid,
                          "items": cart,
                          "status": "pending",
                          "total": total_amount,
                          "created_at": DateTime.now(),
                          "updated_at": DateTime.now(),
                        });
                        await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                          "cart": [],
                          "total_amount": 0,
                        });
                        await FirebaseFirestore.instance.collection("notifications").doc().set({
                          "uid": FirebaseAuth.instance.currentUser!.uid,
                          "message": "Your order has been placed successfully",
                          "type": "order_placed",
                          "created_at": DateTime.now(),
                          "updated_at": DateTime.now(),
                        }).then((value) {
                          NotificationsApi.getToken().then((value) {
                            NotificationsApi.callOnFcmApiSendPushNotifications(
                              title: "Order Placed",
                              body: "Your order has been placed successfully",
                              token: value,
                            );
                          });
                          EasyLoading.dismiss();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderDoneScreen()));
                        });
                      }else{
                        EasyLoading.dismiss();
                      }
                    })
              ]).scrollVertical(),
            )),
      ),
    );
  }
}
