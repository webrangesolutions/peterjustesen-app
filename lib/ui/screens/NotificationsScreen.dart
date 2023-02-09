import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:peterjustesen/ui/screens/OrderdoneScreen.dart';
import 'package:peterjustesen/ui/screens/PaymentScreen.dart';
import 'package:peterjustesen/ui/widgets/AddToCartCard.dart';
import 'package:peterjustesen/ui/widgets/PeterAppBar.dart';
import 'package:peterjustesen/ui/widgets/PeterBottomNavigationBar.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../core/bloc/cart_bloc.dart';
import '../../core/bloc/main_bloc/main_bloc.dart';
import '../../core/constants/constants.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
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
      appBar: PeterAppBar(title: "Notifications"),
      // bottomNavigationBar: PeterBottomNavigationBar(),
      body: Center(
        child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(23),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("notifications").where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shadowColor: Colors.black,
                          elevation: 2,
                          child:
                              NotificationTile(title: snapshot.data!.docs[index]["message"], time: snapshot.data!.docs[index]["updated_at"].toDate().toString().substring(0, 10)),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            )),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  String title;
  String time;

  NotificationTile({Key? key, required this.title, required this.time}) : super();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: custom_montserratTextTheme.headline6!.copyWith(
          color: primaryColor,
          fontSize: 14.sp,
        ),
      ),
      subtitle: Align(
        alignment: Alignment.bottomRight,
        child: Text(
          time,
          style: custom_montserratTextTheme.headline6!.copyWith(
            color: Colors.black,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}
