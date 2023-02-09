import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../core/constants/constants.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(73.h),
          child: AppBar(
            toolbarHeight: 73.h,
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: Text(
              "Reviews",
              style: custom_poppinsTextTheme.headline5?.copyWith(
                color: Color(0xFF333333),
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            leading: GestureDetector(
                child: Icon(Icons.arrow_back_ios, color: Colors.black,),
                onTap: () {
                  Navigator.pop(context);
                }).p24(),
            actions: [
              TextButton(
                onPressed: () {
                  _showMyDialog(context);
                },
                child: Text(
                  "Add Review",
                  style: custom_montserratTextTheme.headline5?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ).px8(),
            ],
          ),
        ),
        body: VStack([
          ReviewCard(
              name: "Patrick Adeleke",
              review:
                  "Very good the hotel is comfortable and also very affordable. the holiday atmosphere is also very supportive and hotel on the betaland",
              img: "profile",
              rating: 10),
          ReviewCard(
              name: "Oluwaseun Pepper",
              review:
                  "The facilities in this hotel are very good and function well. this is very 5 stars for me and I will come back and book a hotel here again",
              img: "f_avatar",
              rating: 10.0),
          ReviewCard(
              name: "Owenfil Desmond",
              review:
                  "The spot that I like about this hotel is the balcony that faces directly the beach. the facilities provided are also very functional, thx huh",
              img: "m_avatar",
              rating: 10.0),
          ReviewCard(
              name: "Owenfil Desmond",
              review:
                  "The spot that I like about this hotel is the balcony that faces directly the beach. the facilities provided are also very functional, thx huh",
              img: "m_avatar",
              rating: 10.0),
        ]).p8().scrollVertical());
  }

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          actionsPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Material(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SizedBox(
                        width: 350.w,
                        height: 220.h,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Give Review",
                                style: custom_montserratTextTheme.headline1
                                    ?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.sp,
                                ),
                              ),
                              25.heightBox,
                              VxRating(
                                onRatingUpdate: (value) {},
                                count: 5,
                                value: 5,
                                normalColor: Colors.grey,
                                selectionColor: Colors.yellow,
                                size: 35,
                              ).centered(),
                              5.heightBox,
                              Text(
                                "Feedback",
                                style: custom_montserratTextTheme.headline2
                                    ?.copyWith(
                                  color: Color(0xFF183046),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                              5.heightBox,
                              Container(
                                height: 100.h,
                                width: 300.w,
                                decoration: BoxDecoration(
                                  color: const Color(0xffbfc7f2),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.r),
                                    border: InputBorder.none,
                                    hintStyle: custom_montserratTextTheme
                                        .headline1
                                        ?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.sp,
                                    ),
                                  ),
                                ),
                              ),
                              5.heightBox,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              height: 59.h,
              width: 1.sw,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20.r),
                ),
              ),
              child: Center(
                  child: Text(
                "Send Review",
                style: custom_montserratTextTheme.headline1?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.sp,
                ),
              )),
            ).onTap(() {
              Navigator.pop(context);
            }),
          ],
        );
      },
    );
  }
}

class ReviewCard extends StatelessWidget {
  String? name;
  String? review;
  String? date;
  String? img;
  double rating;

  ReviewCard({
    this.name,
    this.review,
    this.date,
    this.img,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return VStack([
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HStack(
            [
              CircleAvatar(
                radius: 20.w,
                backgroundImage: AssetImage("assets/images/$img.png"),
              ),
              SizedBox(
                width: 10.w,
              ),
              VStack([
                Text(
                  name!,
                  style: GoogleFonts.montserrat(
                      fontSize: 12.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  "10:00 AM, 20 Oct 2022",
                  style: GoogleFonts.montserrat(
                      fontSize: 10.sp, fontWeight: FontWeight.normal),
                ),
              ]),
            ],
          ),
          12.h.widthBox,
          Expanded(
            child: Column(
              children: [
                VxRating(
                  onRatingUpdate: (value) {},
                  count: 5,
                  value: rating,
                  normalColor: Colors.grey,
                  selectionColor: Colors.yellow,
                  size: 25,
                ).centered(),
                5.heightBox,
              ],
            ),
          ),
        ],
      ),
      SizedBox(
        height: 20.h,
      ),
      Text(
        review!,
        style: custom_poppinsTextTheme.headline5?.copyWith(
          color: Color(0xFF999999),
          fontWeight: FontWeight.normal,
          fontSize: 12.sp,
        ),
      ),
    ]).pLTRB(
      30.w,
      20.h,
      20.w,
      20.h,
    );
  }
}
